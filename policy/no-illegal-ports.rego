package spacelift

deny [ "Illegal port number" ] {
    
    resources := [ changes |
        changes := input.terraform.resource_changes[_]
        changes.type == "aws_security_group"
    ]

    resource = resources[_]

    any([
      resource.change.after.ingress[_].from_port != 22,
      resource.change.after.ingress[_].to_port != 22
    ])
}
