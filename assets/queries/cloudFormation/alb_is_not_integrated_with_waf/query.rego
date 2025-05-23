package Cx

import data.generic.cloudformation as cloudFormationLib

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	cloudFormationLib.isLoadBalancer(resource)
	not internalALB(resource)
	not associatedWAF(name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s' has an 'internal' scheme and a 'WebACLAssociation' associated", [name]),
		"keyActualValue": sprintf("'Resources.%s' doesn't have an 'internal' scheme or a 'WebACLAssociation' associated", [name]),
	}
}

internalALB(resource) {
	scheme := resource.Properties.Scheme
	scheme == "internal"
}

associatedWAF(target_alb) {
	resource := input.document[_].Resources[_]
	resource.Type == "AWS::WAFRegional::WebACLAssociation"
	resource.Properties.ResourceArn.Ref == target_alb
}

associatedWAF(target_alb) {
	resource := input.document[_].Resources[_]
	resource.Type == "AWS::WAFRegional::WebACLAssociation"
	resource.Properties.ResourceArn == target_alb
}
