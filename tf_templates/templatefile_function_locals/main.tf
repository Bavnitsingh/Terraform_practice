locals {
  policy = templatefile("${path.module}/policy.tpl", {
    name = "Bavnit Singh - locals example"
  })
}

output "policy" {
  value = local.policy
}

resource "terraform_data" "pretend_aws_iam_policy" {
  triggers_replace = local.policy

  provisioner "local-exec" {
    command = "echo \"$POLICY\""
    environment = {
      POLICY = local.policy
    }
  }
}