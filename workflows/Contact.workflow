<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Clean_Unsubscribe_Date</fullName>
        <field>Negotium_Unsubscribe_Date__c</field>
        <formula>IF(AND(ISCHANGED(Negotium_Email_Opt_In__c),Negotium_Email_Opt_In__c==true),null,Negotium_Unsubscribe_Date__c)</formula>
        <name>Clean Unsubscribe Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CopyEmailtoExternalID</fullName>
        <field>Email_Identifier__c</field>
        <formula>Email</formula>
        <name>Copy Email to External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Email_to_Subscription_Email</fullName>
        <description>Copies main email to Subscriptions Email Address when Subscriptions Email is blank.</description>
        <field>Subscriptions_Email_Address__c</field>
        <formula>Email</formula>
        <name>Copy Email to Subscriptions Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Delete_Closed_Reason</fullName>
        <field>ENSCampaign_Closed_Reason__c</field>
        <name>Delete Closed Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Delete_Next_Contact_Date</fullName>
        <description>When ENSCampaign Status = Closed, removes the next contact date</description>
        <field>ENSCampaign_Next_Contact__c</field>
        <name>Delete Next Contact Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ENSCampaign_Date_Added</fullName>
        <description>Use current date when Record Type is changed to Client Staff - Target</description>
        <field>ENSCampaign_Date_Added__c</field>
        <formula>$System.OriginDateTime</formula>
        <name>ENSCampaign Date Added</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ENSCampaign_New_Status</fullName>
        <description>Sets Status to &apos;Not Yet Contacted&apos; when Record Type changed to Target</description>
        <field>ENSCampaign_Status__c</field>
        <literalValue>Not Yet Contacted</literalValue>
        <name>ENSCampaign New Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Added_to_Today</fullName>
        <field>ENSCampaign_Date_Added__c</field>
        <formula>$System.OriginDateTime</formula>
        <name>Set Date Added to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_Status</fullName>
        <description>Sets the status to Not Yet Contacted</description>
        <field>ENSCampaign_Status__c</field>
        <literalValue>Not Yet Contacted</literalValue>
        <name>Set Default Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ENSCampaign_Source</fullName>
        <field>ENSCampaign_Source__c</field>
        <literalValue>List</literalValue>
        <name>Set ENSCampaign Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ENS_Lead_Added_Date</fullName>
        <description>add the lead added date</description>
        <field>ENSCampaign_Date_Added__c</field>
        <formula>Today()</formula>
        <name>Update ENS Lead Added Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ENS_Lead_Closed_Date</fullName>
        <field>ENS_Lead_Closed_Date__c</field>
        <formula>Today()</formula>
        <name>Update ENS Lead Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Status_to_closed</fullName>
        <field>ENSCampaign_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Update Lead Status to closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>insert_subscribe_date</fullName>
        <field>Negotium_Subscribe_Date__c</field>
        <formula>IF(Negotium_Email_Opt_In__c==true,text(day(today()))+&apos;/&apos;+TEXT(month(today()))+&apos;/&apos;+TEXT(year(today())),null)</formula>
        <name>insert subscribe date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_subscribe_date</fullName>
        <field>Negotium_Subscribe_Date__c</field>
        <formula>IF(AND(ISCHANGED(Negotium_Email_Opt_In__c),Negotium_Email_Opt_In__c==true),text(day(today()))+&apos;/&apos;+TEXT(month(today()))+&apos;/&apos;+TEXT(year(today())),Negotium_Subscribe_Date__c)</formula>
        <name>update subscribe date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_unsubscribe_date</fullName>
        <field>Negotium_Unsubscribe_Date__c</field>
        <formula>IF(AND(ISCHANGED(Negotium_Email_Opt_In__c),Negotium_Email_Opt_In__c==false),text(day(today()))+&apos;/&apos;+TEXT(month(today()))+&apos;/&apos;+TEXT(year(today())),Negotium_Unsubscribe_Date__c)</formula>
        <name>update unsubscribe date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Email to External ID</fullName>
        <actions>
            <name>CopyEmailtoExternalID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CreatedDate</field>
            <operation>notEqual</operation>
            <value>12/31/1971 5:00 AM</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Email to Subscription Email</fullName>
        <actions>
            <name>Copy_Email_to_Subscription_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Copies the main email address to the subscription email address</description>
        <formula>LEN(Subscriptions_Email_Address__c)=0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ENSCampaign Allocated to Campaign</fullName>
        <actions>
            <name>Set_Date_Added_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Default_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_ENSCampaign_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.ENSCampaign_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Actions to take when a contact is allocated to a Campaign</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ENSCampaign Closed</fullName>
        <actions>
            <name>Delete_Next_Contact_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.ENSCampaign_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Actions to take when an ENS Campaign is closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ENSCampaign Not Closed</fullName>
        <actions>
            <name>Delete_Closed_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.ENSCampaign_Status__c</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Cleans up if changed back to not closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update ENS Lead Added Date</fullName>
        <actions>
            <name>Update_ENS_Lead_Added_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.ENSCampaign_Date_Added__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.ENSCampaign_Status__c</field>
            <operation>equals</operation>
            <value>Follow up required,Not Yet Contacted,Requested Information,Passed to a Network Member,Passed to a BDM,Information Sent,Deferred Contact,Interest in Meeting,Meeting Booked,Meeting Cancelled,Meeting Held (Not Closed),Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update ENS Lead Closed Date</fullName>
        <actions>
            <name>Update_ENS_Lead_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.ENSCampaign_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.ENS_Lead_Closed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>enter the closed date when the ENS Lead Status is marked as closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Status to closed</fullName>
        <actions>
            <name>Update_Lead_Status_to_closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.ENSCampaign_Closed_Reason__c</field>
            <operation>equals</operation>
            <value>Could Not Contact,Left / Moved,Blocked by Gatekeeper,No Interest,Referral(s) Provided,Meeting Held - No Interest,Follow Up as Suspect,Opportunity Created,Public Program Registration,Abandoned,Price too high,Competitor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.ENSCampaign_Status__c</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>change the lead status to closed, when a closed reason is added</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Subscribe and Unsubscribe Dates</fullName>
        <actions>
            <name>Clean_Unsubscribe_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_subscribe_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_unsubscribe_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CreatedDate</field>
            <operation>notEqual</operation>
            <value>12/31/1899 6:00 AM</value>
        </criteriaItems>
        <description>update &apos;Negotium Subscribe/Unsubscribe Dates&apos; fields</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>insert subscribe date</fullName>
        <actions>
            <name>insert_subscribe_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CreatedDate</field>
            <operation>notEqual</operation>
            <value>12/31/1899 6:00 AM</value>
        </criteriaItems>
        <description>Insert subscribe date when  a contact created with Negotium_Email_Opt_In field ticked</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
