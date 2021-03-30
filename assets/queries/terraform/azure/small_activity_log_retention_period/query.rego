package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	monitor := input.document[i].resource.azurerm_monitor_log_profile[name]

	object.get(monitor, "retention_policy", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_monitor_log_profile[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy' is defined", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy' is undefined", [name]),
	}
}

CxPolicy[result] {
	monitor := input.document[i].resource.azurerm_monitor_log_profile[name]

	monitor.retention_policy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_monitor_log_profile[%s].retention_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.enabled' is set to false", [name]),
	}
}

CxPolicy[result] {
	monitor := input.document[i].resource.azurerm_monitor_log_profile[name]

	monitor.retention_policy.enabled == true
	retentionPolicy := monitor.retention_policy
	commonLib.between(retentionPolicy.days, 1, 364)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_monitor_log_profile[%s].retention_policy.days", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' is greater than 365 days or 0 (indefinitely)", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' is lesser than 365 days or different than 0 (indefinitely)", [name]),
	}
}
