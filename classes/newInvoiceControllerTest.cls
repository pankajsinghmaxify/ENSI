@isTest
public class newInvoiceControllerTest {

    @isTest
    public static void testNewInvoiceController() {
        
        Account a = new Account(Name = 'Test Organisation');

		insert a;

		List<Contact> cons = new List<Contact>{
				new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = a.Id),
				new Contact(FirstName = 'Test 2', LastName = 'Contact', AccountId = a.Id)
				};

		insert cons;
        
        INVT__Invoice_Tax_Rate__c itr = new INVT__Invoice_Tax_Rate__c(Name = 'Test Tax');

		insert itr;

		INVT__Invoice_Account__c ia = new INVT__Invoice_Account__c(INVT__Code__c = '42021', Name = 'Test Account', INVT__Invoice_Tax_Type__c = itr.Id);

		insert ia;

		INVT__Invoice_Branding_Theme__c ibt = new INVT__Invoice_Branding_Theme__c(Name = 'Thank you');

		insert ibt;
        
        INVT__Invoice_Item__c ii = new INVT__Invoice_Item__c(INVT__Code__c = '42021', Name = 'Test Item', INVT__Is_Sold__c = true, INVT__Sales_Invoice_Account__c = ia.Id, INVT__Sales_Invoice_Tax_Type__c = itr.Id, INVT__Description__c = 'Test Description');

        insert ii;
        
		INVT__Invoice_Tracking_Category__c cat1 = new INVT__Invoice_Tracking_Category__c(Name = 'Categories');
		INVT__Invoice_Tracking_Category__c cat2 = new INVT__Invoice_Tracking_Category__c(Name = 'Jobs');

		insert new List<INVT__Invoice_Tracking_Category__c>{cat1, cat2};

		INVT__Invoice_Tracking_Option__c opt1 = new INVT__Invoice_Tracking_Option__c(Name = '100 - Tied', INVT__Invoice_Tracking_Category__c = cat1.Id);
		INVT__Invoice_Tracking_Option__c opt2 = new INVT__Invoice_Tracking_Option__c(Name = 'TESTPROJ', INVT__Invoice_Tracking_Category__c = cat2.Id);

		insert new List<INVT__Invoice_Tracking_Option__c>{opt1, opt2};
            
        Id pricebookId = Test.getStandardPricebookId();
            
        Product2 prod1 = new Product2(Name = 'Test Prod1', Xero_product_codes__c = '42021', isActive = true, Product_Type__c = 'Material', Invoice_line_item_description__c = 'Test Desc 1');
        Product2 prod2 = new Product2(Name = 'Test Prod2', Xero_product_codes__c = '42021', isActive = true, Product_Type__c = 'Expense');
        Product2 prod3 = new Product2(Name = 'Test Prod2', Xero_product_codes__c = '42021', isActive = true, Product_Type__c = 'Handout');
        
        insert new List<Product2>{prod1, prod2, prod3};
            
        PriceBookEntry pbe1 = new PriceBookEntry(Product2Id = prod1.Id, Pricebook2Id = pricebookId, UnitPrice = 100, isActive = true);
        PriceBookEntry pbe2 = new PriceBookEntry(Product2Id = prod2.Id, Pricebook2Id = pricebookId, UnitPrice = 200, isActive = true);
        PriceBookEntry pbe3 = new PriceBookEntry(Product2Id = prod3.Id, Pricebook2Id = pricebookId, UnitPrice = 300, isActive = true);

        insert new List<PricebookEntry>{pbe1, pbe2, pbe3};
            
        RecordType rt = [SELECT Id, DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'In_House' LIMIT 1];
        
        Opportunity op = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today(), Client_Account__c = a.Id, RecordTypeId = rt.Id);
            
        insert op;
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = op.Id, Product2Id = prod1.Id, PriceBookEntryId = pbe1.Id, UnitPrice = 100, Quantity = 10, Product_type__c = 'Material');
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = op.Id, Product2Id = prod2.Id, PriceBookEntryId = pbe2.Id, UnitPrice = 200, Quantity = 20, Product_type__c = 'Expense');
        OpportunityLineItem oli3 = new OpportunityLineItem(OpportunityId = op.Id, Product2Id = prod3.Id, PriceBookEntryId = pbe3.Id, UnitPrice = 300, Quantity = 30, Product_type__c = 'Handout');
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = op.Id, Product2Id = prod1.Id, PriceBookEntryId = pbe1.Id, UnitPrice = 100, Quantity = 15, Product_type__c = 'Material');
        
        insert new List<OpportunityLineItem>{oli1, oli2, oli3, oli4};
            
        Test.startTest();
        
        newInvoiceController.getOpportunity(op.Id);
        newInvoiceController.getLineItems(op.Id);
        newInvoiceController.getInvoicePercents();
        
        newInvoiceController.newInvoice(op.Id, 25, false);
        newInvoiceController.newInvoice(op.Id, 35, false);
        newInvoiceController.newInvoice(op.Id, null, true);
        
        Test.stopTest();
    }
    
    
}