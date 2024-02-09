
resource "spacelift_stack" "terra_stack" {
  name       = var.stack_name
  branch     = "main"
  repository = "sapcelift_with_terraform"
}


resource "spacelift_policy" "illegal_ports" {
  name = "Policy-01"
  body = file("${path.module}/policy/no-illegal-ports.rego")
  type = "PLAN"
}

resource "spacelift_policy_attachment" "illegal_ports_attachment" {
  policy_id = spacelift_policy.illegal_ports.id
  stack_id  = spacelift_stack.terra_stack.id
}


resource "spacelift_policy" "enforce_cloud_provider" {
  name = "Policy-02"
  body = file("${path.module}/policy/enforce-cloud-provider.rego")
  type = "PLAN"
}

resource "spacelift_policy_attachment" "enforce_cloud_provider_attachment" {
  policy_id = spacelift_policy.enforce_cloud_provider.id
  stack_id  = spacelift_stack.terra_stack.id
}




resource "spacelift_policy" "instance_size_policy" {
  name = "Policy-03"
  body = file("${path.module}/policy/instance-size-policy.rego")
  type = "PLAN"
}

resource "spacelift_policy_attachment" "instance_size_policy_attachment" {
  policy_id = spacelift_policy.instance_size_policy.id
  stack_id  = spacelift_stack.terra_stack.id
}
