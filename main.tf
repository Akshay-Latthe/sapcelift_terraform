resource "spacelift_policy" "illegal_ports" {
  name = "Illegal Ports Policy"
  body = file("${path.module}/policy/no-illegal-ports.rego")
  type = "PLAN"
}



resource "spacelift_stack" "terra_stack" {
  name       = var.stack_name
  branch     = "main"
  repository = "example-repo"
}

resource "spacelift_policy_attachment" "illegal_ports_attachment" {
  policy_id = spacelift_policy.illegal_ports.id
  stack_id  = spacelift_stack.terra_stack.id
}
