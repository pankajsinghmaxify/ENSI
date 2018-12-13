<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Opportunity_NAM_contacted</fullName>
        <description>Opportunity NAM contacted</description>
        <protected>false</protected>
        <recipients>
            <recipient>lforster.ens@negotiate.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Opportunity_NAM_contacted</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_assigned</fullName>
        <description>Opportunity assigned</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_BDM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Opportunity_assigned</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Opp_Sales_mgr_contacted</fullName>
        <field>Sales_mgr_informed_NAM_contact__c</field>
        <literalValue>1</literalValue>
        <name>Update Opp - Sales mgr contacted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>New Opportunity assigned</fullName>
        <actions>
            <name>Opportunity_assigned</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Assigned_BDM__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>DEACTIVATED. BDMs will already receive a new task notification from the system.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity NAM contacted</fullName>
        <actions>
            <name>Opportunity_NAM_contacted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Opp_Sales_mgr_contacted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sales_mgr_informed_NAM_contact__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>NAM Contacted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
