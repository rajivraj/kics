package Cx

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Type == "AWS::MSK::Cluster"
	properties := resources.Properties
	object.get(properties, "LoggingInfo", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LoggingInfo is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LoggingInfo is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::MSK::Cluster"
	properties := resource.Properties

	properties.LoggingInfo

	not properties.LoggingInfo.BrokerLogs.CloudWatchLogs
	not properties.LoggingInfo.BrokerLogs.Firehose
	not properties.LoggingInfo.BrokerLogs.S3

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs should have at least one of the following keys: 'CloudWatchLogs', 'Firehose' or 'S3'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs 'CloudWatchLogs', 'firehose' and 's3' do not exist", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::MSK::Cluster"
	properties := resource.Properties
	logs := properties.LoggingInfo.BrokerLogs[log]
	isResFalse(logs.Enabled)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs.%s.Enabled", [name, log]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs.%s is enabled", [name, log]),
		"keyActualValue": sprintf("Resources.%s.Properties.LoggingInfo.BrokerLogs.%s is disabled", [name, log]),
	}
}

isResFalse(answer) {
	answer == "false"
} else {
	answer == false
}
