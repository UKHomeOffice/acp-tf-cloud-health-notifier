resource "aws_sns_topic" "project" {

  for_each = var.project_name_email_map

  name = "${var.sns_topic_prefix}_${each.key}"
}

locals {
  email_by_project = flatten([
    for project_name, email_list in var.project_name_email_map : [
      for email in email_list : {
        project = project_name
        email    = email
      }
    ]
  ])
}

resource "aws_sns_topic_subscription" "project_endpoint" {

  for_each = local.email_by_project

  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.sns_topic_prefix}_${each.project}"
  protocol  = "email"
  endpoint  = each.email
}
