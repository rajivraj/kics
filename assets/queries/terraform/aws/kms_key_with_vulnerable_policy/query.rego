package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]

	statement.Principal.AWS == "*"
	statement.Action[_] == "kms:*"
	statement.Resource == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kms_key[%s].policy definition is correct", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].policy definition is incorrect", [name]),
	}
}
