<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Job_not_mass_updated</fullName>
        <ccEmails>mike@curioushuman.com.au</ccEmails>
        <description>Job not mass updated</description>
        <protected>false</protected>
        <recipients>
            <recipient>mike@curioushuman.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Job_not_mass_updated</template>
    </alerts>
    <fieldUpdates>
        <fullName>CopyJobNumbertoIdentifier</fullName>
        <field>Job_Number_Identifier__c</field>
        <formula>Name</formula>
        <name>Copy Job Number to Identifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Erase_ClosedReason</fullName>
        <field>Closed_Reason__c</field>
        <name>Erase ClosedReason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Erase_Closed_Date</fullName>
        <field>Proposal_Rejected_Date__c</field>
        <name>Erase Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_to_Job</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Job</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type to Job</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_to_Opportunity</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Opportunity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type to Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Closed_Date_to_Today</fullName>
        <field>Proposal_Rejected_Date__c</field>
        <formula>Today()</formula>
        <name>Set Closed Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Completed_Date_to_Today</fullName>
        <field>Completed_Date__c</field>
        <formula>Today()</formula>
        <name>Set Completed Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_cancelled_date_as_today</fullName>
        <field>Cancelled_Date__c</field>
        <formula>Today()</formula>
        <name>Set cancelled date as today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_Date_Created</fullName>
        <field>OPP_Date_Created__c</field>
        <formula>Today()</formula>
        <name>Update Opp Date Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postponed_Date</fullName>
        <field>Postponed_Date__c</field>
        <formula>Today()</formula>
        <name>Update Postponed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proposal_date</fullName>
        <description>add proposal date as today</description>
        <field>Proposal_Date__c</field>
        <formula>Today()</formula>
        <name>Update Proposal date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proposal_date_Tentative_Status</fullName>
        <field>Proposal_Date__c</field>
        <formula>Today ()</formula>
        <name>Update Proposal date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_FX_with_Opp_FX</fullName>
        <field>Recon_Total_JobValue_FX__c</field>
        <formula>OPP_FX_Value_Estimate__c</formula>
        <name>Update Total FX with Opp FX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_confirmed_date</fullName>
        <field>Confirmed_Date__c</field>
        <formula>Today()</formula>
        <name>Update confirmed date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Job Number to Identifier</fullName>
        <actions>
            <name>CopyJobNumbertoIdentifier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.CreatedDate</field>
            <operation>notEqual</operation>
            <value>12/31/1971 5:00 AM</value>
        </criteriaItems>
        <description>To create an external ID for data loading</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Job Not Closed</fullName>
        <actions>
            <name>Erase_ClosedReason</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Erase_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Job Status is Cancelled with no Cancelled Date</fullName>
        <actions>
            <name>Set_cancelled_date_as_today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.Cancelled_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>In which case sets Completed Date to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Job Status is Closed with no Closed Date</fullName>
        <actions>
            <name>Set_Closed_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.Proposal_Rejected_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>In which case sets Closed Date to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Job Status is Completed with no Completed Date</fullName>
        <actions>
            <name>Set_Completed_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.Completed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>In which case sets Completed Date to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Job Status is Confirmed with no Confirmed  Date</fullName>
        <actions>
            <name>Update_confirmed_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.Confirmed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>In which case sets Confirmed Date to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Job Status is Postponed with no Postponed Date</fullName>
        <actions>
            <name>Update_Postponed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Postponed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.Postponed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>In which case sets Postponed Date to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Job Status is Proposed with no Proposed  Date</fullName>
        <actions>
            <name>Update_Proposal_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Proposed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.Proposal_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>In which case sets Proposed Date to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Job Status is Tentative with no Proposed  Date</fullName>
        <actions>
            <name>Update_Proposal_date_Tentative_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Tentative</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.Proposal_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>In which case sets Proposed Date to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity with no Opp Date Created</fullName>
        <actions>
            <name>Update_Opp_Date_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.OPP_Date_Created__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>In which case sets Opp Date Created to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status is for RecType%3DJob only</fullName>
        <actions>
            <name>Record_Type_to_Job</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Postponed,Confirmed,Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Job,Public Program,Consulting and Retainers</value>
        </criteriaItems>
        <description>Status is for RecType=Job only</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status is for RecType%3DOpportunity only</fullName>
        <actions>
            <name>Record_Type_to_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Waiting for Client,Proposal Requested,ENS to Follow Up,Proposed</value>
        </criteriaItems>
        <description>Status is for RecType=Opportunity only</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Total FX with Opp FX</fullName>
        <actions>
            <name>Update_Total_FX_with_Opp_FX</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.Recon_Total_JobValue_FX__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>update Total Value Agreed FX with OPP FX Value Estimate</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>testing</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Job__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Job__c.Name</field>
            <operation>equals</operation>
            <value>J-04331</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
