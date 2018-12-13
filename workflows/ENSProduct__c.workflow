<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CopynametoexternalID</fullName>
        <field>Old_Deliverable__c</field>
        <formula>Name</formula>
        <name>Copy name to external ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update external ID</fullName>
        <actions>
            <name>CopynametoexternalID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ENSProduct__c.CreatedDate</field>
            <operation>notEqual</operation>
            <value>12/31/1949 6:00 AM</value>
        </criteriaItems>
        <description>Copy name to external ID.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
