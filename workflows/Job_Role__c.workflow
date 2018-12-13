<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateexternalID</fullName>
        <field>Old_Job_Person_Role__c</field>
        <formula>Job__c   &amp;  Contact__r.Old_Person_ID__c  &amp;  &quot;Present&quot;</formula>
        <name>Update external ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update external ID</fullName>
        <actions>
            <name>UpdateexternalID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job_Role__c.CreatedDate</field>
            <operation>notEqual</operation>
            <value>12/31/1949 6:00 AM</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
