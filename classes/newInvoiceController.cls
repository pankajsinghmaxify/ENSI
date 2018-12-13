global class newInvoiceController {
    
    public static List<String> ignoredProdTypes = new List<String>{'Case study','Handout','Other'};
    
    @AuraEnabled
    public static Opportunity getOpportunity(String opportunityId) {
        
        List<Opportunity> ops = [SELECT Id, Amount, Amount_invoiced_so_far__c, Amount_invoiced_so_far_value__c 
                                 FROM Opportunity 
                                 WHERE Id = :opportunityId];
        
        if(!ops.isEmpty()) {
            return ops[0];
        } else {
            throw new AuraHandledException('No Opportunity Found.');
        }
        
    }
    
    @AuraEnabled
    public static List<OpportunityLineItem> getLineItems(String opportunityId) {
        
        List<OpportunityLineItem> olis = [SELECT Id, TotalPrice, Quantity, UnitPrice, Amount_invoiced_so_far__c, Product_Type__c
                                          FROM OpportunityLineItem
                                          WHERE OpportunityId = :opportunityId AND Product_Type__c NOT IN :ignoredProdTypes];
        
        if(!olis.isEmpty()) {
            return olis;
        } else {
            throw new AuraHandledException('No Opportunity Products Found.');
        }
        
    }
    
    @AuraEnabled
    public static List<Integer> getInvoicePercents() {
        List<Integer> options = new List<Integer>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Invoice_Percent__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            if(String.isNotBlank(f.getValue())) {
                try {
                    options.add(Integer.valueOf(f.getValue())); 
                } catch(Exception e){}
            }
        }
        return options;
    }
    
    @AuraEnabled
    public static String newInvoice(Id opportunityId, Decimal invoicePercent, Boolean finalize) {
        
        List<Opportunity> ops = [SELECT Id, Name, Amount, Amount_invoiced_so_far__c, Xero_ID__c,
                                 Amount_invoiced_so_far_value__c, Contact_for_invoice__c,
                                 Contact_for_invoice__r.AccountId, CurrencyIsoCode,
                                 (SELECT Id, TotalPrice, Quantity, UnitPrice, 
                                  Amount_invoiced_so_far__c, Product2Id, Product2.Xero_product_codes__c,
                                  Product2.Invoice_line_item_description__c, Product2.Name, Product_Type__c
                                  FROM OpportunityLineItems
                                  WHERE Product_Type__c NOT IN :ignoredProdTypes) 
                                 FROM Opportunity 
                                 WHERE Id = :opportunityId];
        
        if(!ops.isEmpty()) {
            Opportunity op = ops[0];
            
            INVT__Invoice_Branding_Theme__c bTheme = [SELECT Id FROM INVT__Invoice_Branding_Theme__c WHERE Name = 'Thank you' LIMIT 1];
            
            INVT__Invoice__c inv = new INVT__Invoice__c(
                INVT__Date__c = Date.today(),
                INVT__Due_Date__c = Date.today().addDays(30),
                INVT__Reference__c = op.Xero_ID__c,
                INVT__Contact__c = op.Contact_for_invoice__c,
                INVT__Opportunity__c = op.Id,
                INVTX__Send_Email__c = 'No',
                INVT__Sync_with_Partner__c = 'No',
                INVT__Type__c = 'ACCREC',
                INVT__Line_Amount_Type__c = 'Exclusive',
                INVT__Status__c = 'DRAFT',
                INVT__Branding_Theme__c = bTheme.Id,
                INVTX__Update_PDF__c = 'Yes',
                Invoice_Percent__c = (finalize == null || !finalize ? invoicePercent : (op.Amount_invoiced_so_far__c != null ? 100 - op.Amount_invoiced_so_far__c : 0))
            );
            
            if(String.isNotBlank(op.CurrencyIsoCode)) {
                List<INVTX__Invoice_Currency__c> currencies = [SELECT Id FROM INVTX__Invoice_Currency__c WHERE Name = :op.CurrencyIsoCode];
                if(!currencies.isEmpty()) {
                    inv.INVTX__Currency__c = currencies[0].Id;
                }
            }
            
            try {
                insert inv;
            } catch(DmlException ex) {
                throw new AuraHandledException(ex.getMessage());
            }
            
            
            Set<String> itemCodes = new Set<String>();
            List<OpportunityLineItem> olis = new List<OpportunityLineItem>();

            if(!op.OpportunityLineItems.isEmpty()) {        
                for(OpportunityLineItem oli : op.OpportunityLineItems) {
                    
                    if(op.Amount_invoiced_so_far__c == NULL || 
                       op.Amount_invoiced_so_far__c == 0 || 
                       finalize || 
                       (oli.Amount_invoiced_so_far__c != null && 
                        oli.Amount_invoiced_so_far__c > 0)) {
                            if(String.isNotBlank(oli.Product2Id) && String.isNotBlank(oli.Product2.Xero_product_codes__c)) {
                                itemCodes.add(oli.Product2.Xero_product_codes__c);
                            }
                            
                            olis.add(oli);
                        }
                }
            }
            
            Map<String, INVT__Invoice_Item__c> itemMap = new Map<String, INVT__Invoice_Item__c>();
            
            if(!itemCodes.isEmpty()) {
                for(INVT__Invoice_Item__c ii : [SELECT Id, INVT__Sales_Invoice_Account__c, INVT__Sales_Invoice_Tax_Type__c, INVT__Code__c,
                                               INVT__Description__c FROM INVT__Invoice_Item__c WHERE INVT__Code__c IN :itemCodes]) {
                                                   itemMap.put(ii.INVT__Code__c, ii);
                                               }
            }
            
            List<INVT__Invoice_Line_Item__c> ilis = new List<INVT__Invoice_Line_Item__c>();
            Map<String, INVT__Invoice_Line_Item__c> expenseILIMap = new Map<String, INVT__Invoice_Line_Item__c>();
            Map<String, INVT__Invoice_Line_Item__c> finalILIMap = new Map<String, INVT__Invoice_Line_Item__c>();
            
            if(!olis.isEmpty()) {
                for(OpportunityLineItem oli : olis) {
                    
                    INVT__Invoice_Line_Item__c ili = new INVT__Invoice_Line_Item__c(
                        INVT__Invoice__c = inv.Id,
                        INVT__Unit_Amount__c = oli.UnitPrice,
                        INVT__Quantity__c = 0
                    );
                    
                    if(oli.Amount_invoiced_so_far__c == null) 
                        oli.Amount_invoiced_so_far__c = 0;
                    
                    if(oli.Product_Type__c == 'Expense') {
                        
                        if(expenseILIMap.containsKey(oli.Product2.Name)) {
                            ili = expenseILIMap.get(oli.Product2.Name);
                        } else {
                            ili.INVT__Quantity__c = 1;
                            ili.INVT__Unit_Amount__c = 0;
                            expenseILIMap.put(oli.Product2.Name, ili);
                        }
                        
                        Decimal liTotal;
                        
                        if(finalize) {
                            liTotal = (oli.UnitPrice*oli.Quantity) - oli.Amount_invoiced_so_far__c;
                        } else {
                            liTotal = oli.UnitPrice * (invoicePercent/100);                        
                        }
                        
                        oli.Amount_invoiced_so_far__c += liTotal;
                        ili.INVT__Unit_Amount__c += liTotal;
                        
                    } else if(finalize) {
                        
                        if(finalILIMap.containsKey(oli.Product2Id)) {
                            ili = finalILIMap.get(oli.Product2Id);
                        } else {
                            finalILIMap.put(oli.Product2Id, ili);
                        }
                        
                        Decimal liTotal = oli.Quantity - (oli.Amount_invoiced_so_far__c/oli.UnitPrice);
                        ili.INVT__Quantity__c += liTotal;
                        oli.Amount_invoiced_so_far__c += ili.INVT__Unit_Amount__c * liTotal;
                        
                    } else {
                        
                        ili.INVT__Quantity__c += oli.Quantity * (invoicePercent/100);
                        oli.Amount_invoiced_so_far__c += ili.INVT__Unit_Amount__c * ili.INVT__Quantity__c;
                        ilis.add(ili);
                        
                    }
                    
                    if(String.isNotBlank(oli.Product2Id) && String.isNotBlank(oli.Product2.Xero_product_codes__c)) {
                        
                        if(itemMap.containsKey(oli.Product2.Xero_product_codes__c)) {
                            INVT__Invoice_Item__c item = itemMap.get(oli.Product2.Xero_product_codes__c);
                            ili.INVT__Invoice_Account__c = item.INVT__Sales_Invoice_Account__c;
                            ili.INVT__Invoice_Item__c = item.Id;
                            ili.INVT__Invoice_Tax_Type__c = item.INVT__Sales_Invoice_Tax_Type__c;
                        } 
                        
                        if(String.isNotBlank(oli.Product2.Invoice_line_item_description__c)) {
                            ili.INVT__Description__c = oli.Product2.Invoice_line_item_description__c;
                        } else {
                            ili.INVT__Description__c = oli.Product2.Name;
                        }
                    }
                   
                }
                
                ilis.addAll(expenseILIMap.values());
                ilis.addAll(finalILIMap.values());
                
                if(!ilis.isEmpty()) {
                    try {
                        insert ilis;
                    } catch(DmlException ex) {
                        System.debug(ex);
                        throw new AuraHandledException('Failed to insert Line Items: ' + ex.getMessage());
                    }
                    
                    try {
                        update olis;
                    } catch(DmlException ex) {
                        System.debug(ex);
                        throw new AuraHandledException('Failed to update Opportunity Products: ' + ex.getMessage());
                    }
                    
                    try {
                        if(op.Amount_invoiced_so_far__c == null)
                        	op.Amount_invoiced_so_far__c = 0;
                        
                        op.Amount_invoiced_so_far__c = finalize ? 100 : op.Amount_invoiced_so_far__c + invoicePercent;
                        update op;
                    } catch(DmlException ex) {
                        System.debug(ex);
                        throw new AuraHandledException('Failed to update Opportunity: ' + ex.getMessage());
                    }

                }
            }
            
            return inv.Id;
            
        } else {
            throw new AuraHandledException('Unable to retrieve Opportunity.');
        }
        
        
    }
}