
resource "spacelift_stack" "example-stack" {
  name              = var.new_stack_name
  administrative    = true
  autodeploy        = false
  branch            = "master"
  description       = "Shared production infrastructure"
  repository        = "testing-spacelift"
  terraform_version = "0.12.27"
}

resource "spacelift_stack" "main_stack" {
  name       = var.main_stack
  branch     = "main"
  repository = "sapcelift_with_terraform"
}

resource "spacelift_stack" "dev_stack" {
  name       = var.dev_stack
  branch     = "dev"
  repository = "sapcelift_with_terraform"
}

# Policies
resource "spacelift_policy" "illegal_ports" {
  name = "Policy-01"
  body = file("${path.module}/policy/no-illegal-ports.rego")
  type = "PLAN"
}

resource "spacelift_policy" "enforce_cloud_provider" {
  name = "Policy-02"
  body = file("${path.module}/policy/enforce-cloud-provider.rego")
  type = "PLAN"
}

resource "spacelift_policy" "instance_size_policy" {
  name = "Policy-03"
  body = file("${path.module}/policy/instance-size-policy.rego")
  type = "PLAN"
}

# Attach policies to all stacks
locals {
  stacks = {
    example-stack = spacelift_stack.example-stack
    main_stack    = spacelift_stack.main_stack
    dev_stack     = spacelift_stack.dev_stack
  }
}

resource "spacelift_policy_attachment" "policy_attachments" {
  for_each  = local.stacks
  stack_id  = each.value.id
  policy_id = spacelift_policy.illegal_ports.id
}

resource "spacelift_policy_attachment" "policy_attachments_2" {
  for_each  = local.stacks
  stack_id  = each.value.id
  policy_id = spacelift_policy.enforce_cloud_provider.id
}

resource "spacelift_policy_attachment" "policy_attachments_3" {
  for_each  = local.stacks
  stack_id  = each.value.id
  policy_id = spacelift_policy.instance_size_policy.id
}

