<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Account_GROUP</fullName>
        <field>Account_GROUP__c</field>
        <formula>IF( LEN(  Parent.Name  )=0 ,  Name ,  Parent.Account_GROUP__c )</formula>
        <name>Update Account GROUP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Nam_of_Parent_Text</fullName>
        <field>SicDesc</field>
        <formula>&quot;Run&quot;</formula>
        <name>Update Nam of Parent Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Processing_Field</fullName>
        <field>Processing_Field_for_Updates__c</field>
        <formula>&quot;run&quot;</formula>
        <name>Update Processing Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatedDescriptionSummary</fullName>
        <description>Updates Description Summary.</description>
        <field>Description_Summary__c</field>
        <formula>if( 
len( Description ) &gt; 251, 
left( Description,251) &amp; &quot; ...&quot;, 
Description 
)</formula>
        <name>Updated Description Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check RT dupes</fullName>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>contains</operation>
            <value>Rio Tinto</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>contains</operation>
            <value>RT</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Account</fullName>
        <actions>
            <name>Update_Account_GROUP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Forced trigger on account create or edit</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Updated Description Summary</fullName>
        <actions>
            <name>UpdatedDescriptionSummary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>12/31/1949 6:00 AM</value>
        </criteriaItems>
        <description>Copies the first 255 characters from Description into Description Summary.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>update Nam of Direct Parent</fullName>
        <actions>
            <name>Update_Processing_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
