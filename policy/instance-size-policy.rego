package spacelift

deny["Policy was denied"] {
    instance := input.terraform.resource_changes[_].change.after.instance_type
    instance != sanitized("t2.micro")
}

sample { true }
