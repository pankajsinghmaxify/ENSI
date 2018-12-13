<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Task_alert</fullName>
        <description>Task alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Task_alert</template>
    </alerts>
    <alerts>
        <fullName>Task_reminder</fullName>
        <description>Task reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Task_reminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>Mark_Task_Public_to_True</fullName>
        <field>IsVisibleInSelfService</field>
        <literalValue>1</literalValue>
        <name>Mark Task Public to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCommentsSummary</fullName>
        <field>Comment_Summary__c</field>
        <formula>if(  
     len( Description ) &gt; 251, 
          left( Description,251) &amp; &quot; ...&quot;,
          Description
)</formula>
        <name>Update Comments Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Mark Task Public to True</fullName>
        <actions>
            <name>Mark_Task_Public_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Task email reminder</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.IsReminderSet</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>DEACTIVATED for now. Until we can get the BDMs using the system.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Task_reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ReminderDateTime</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Comments Summary</fullName>
        <actions>
            <name>UpdateCommentsSummary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>12/31/1949 6:00 AM</value>
        </criteriaItems>
        <description>Updates the Comments Summary field with the first 255 characters from Comments.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
