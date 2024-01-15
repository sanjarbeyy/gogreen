# resource "aws_iam_user" "sysadmin1" {
#   name = "sysadmin1"

#   tags = {
#     tag-key = "tag-value"
#   }
# }
# resource "aws_iam_access_key" "sysadmin1" {
#   user = aws_iam_user.sysadmin1.name
# }

# # resource "aws_iam_user_policy_attachment" "sysadmin1_policy" {
# #   user       = aws_iam_user.sysadmin1.name
# #   policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
# # }

# # resource "aws_iam_virtual_mfa_device" "sysadmin1_mfa_device" {
# #   virtual_mfa_device_name = "sysadmin1_mfa_device"
# #   user_name = aws_iam_user.sysadmin1.id
# # }

# resource "aws_iam_user" "sysadmin2" {
#   name = "sysadmin2"

#   tags = {
#     tag-key = "tag-value"
#   }
# }
# resource "aws_iam_access_key" "sysadmin2" {
#   user = aws_iam_user.sysadmin2.name
# }

# # resource "aws_iam_virtual_mfa_device" "mfa_device" {
# #   for_each = var.iam_user_names
# #   virtual_mfa_device_name = "mfa_device"
# #   user_name               = [aws_aim_user.sysadmin1, aws_aim_user.sysadmin2]
# # }


# resource "aws_iam_user" "dbadmin1" {
#   name = "dbadmin1"

#   tags = {
#     tag-key = "tag-value"
#   }
# }
# resource "aws_iam_access_key" "dbadmin1" {
#   user = aws_iam_user.dbadmin1.name
# }

# resource "aws_iam_user" "dbadmin2" {
#   name = "dbadmin2"

#   tags = {
#     tag-key = "tag-value"
#   }
# }
# resource "aws_iam_access_key" "dbadmin2" {
#   user = aws_iam_user.dbadmin2.name
# }

# resource "aws_iam_user" "monitor1" {
#   name = "monitor1"

#   tags = {
#     tag-key = "tag-value"
#   }
# }
# resource "aws_iam_access_key" "monitor1" {
#   user = aws_iam_user.monitor1.name
# }

# resource "aws_iam_user" "monitor2" {
#   name = "monitor2"

#   tags = {
#     tag-key = "tag-value"
#   }
# }
# resource "aws_iam_access_key" "monitor2" {
#   user = aws_iam_user.monitor2.name
# }

# resource "aws_iam_user" "monitor3" {
#   name = "monitor3"

#   tags = {
#     tag-key = "tag-value"
#   }
# }
# resource "aws_iam_access_key" "monitor3" {
#   user = aws_iam_user.monitor3.name
# }

# resource "aws_iam_user" "monitor4" {
#   name = "monitor4"

#   tags = {
#     tag-key = "tag-value"
#   }
# }
# resource "aws_iam_access_key" "monitor4" {
#   user = aws_iam_user.monitor4.name
# }

# resource "aws_iam_group" "system_admins" {
#   name = "system-administrators"
# }

# resource "aws_iam_group" "database_admins" {
#   name = "database-administrators"
# }

# resource "aws_iam_group" "monitoring_group" {
#   name = "monitoring-group"
# }

# resource "aws_iam_group_membership" "database_admins" {
#   name  = "database_administrators"
#   users = [aws_iam_user.dbadmin1.name, aws_iam_user.dbadmin2.name, ]
#   group = aws_iam_group.database_admins.name
# }

# resource "aws_iam_group_membership" "system_admins" {
#   name  = "system_adminstrators"
#   users = [aws_iam_user.sysadmin1.name, aws_iam_user.sysadmin2.name]
#   group = aws_iam_group.system_admins.name
# }

# resource "aws_iam_group_membership" "monitoring_group" {
#   name  = "monitoring-group"
#   users = [aws_iam_user.monitor1.name, aws_iam_user.monitor2.name, aws_iam_user.monitor3.name, aws_iam_user.monitor4.name]
#   group = aws_iam_group.monitoring_group.name
# }

# # locals {
# #    sysadmin1_keys_csv = "access_key,secret_key\n${aws_iam_access_key.sysadmin1_access_key.id},${aws_iam_access_key.achintha_access_key.secret}"
# #  }


# # resource "local_file" "sysadmin1_keys" {
# #  content  = local.sysadmin1_keys_csv
# #    filename = "asysadmin1-keys.csv"
# # }

resource "aws_iam_user" "users" {
  for_each = var.iam_user
  name     = each.value.name
  tags     = each.value["tags"]
}

resource "aws_iam_user_login_profile" "password" {
  for_each = aws_iam_user.users
  user     = aws_iam_user.users[each.key].name
}

resource "aws_iam_group" "system_admins" {
  name = "system-administrators"
}

resource "aws_iam_group" "database_admins" {
  name = "database-administrators"
}

resource "aws_iam_group" "monitoring_group" {
  name = "monitoring-group"
}

resource "aws_iam_group_membership" "database_admins" {
  name  = "database_administrators"
  users = [aws_iam_user.users["dbadmin1"].name, aws_iam_user.users["dbadmin2"].name, ]
  group = aws_iam_group.database_admins.name
}

resource "aws_iam_group_membership" "system_admins" {
  name  = "system_adminstrators"
  users = [aws_iam_user.users["sysadmin1"].name, aws_iam_user.users["sysadmin2"].name]
  group = aws_iam_group.system_admins.name
}

resource "aws_iam_group_membership" "monitoring_group" {
  name  = "monitoring-group"
  users = [aws_iam_user.users["monitor1"].name, aws_iam_user.users["monitor2"].name, aws_iam_user.users["monitor3"].name, aws_iam_user.users["monitor4"].name]
  group = aws_iam_group.monitoring_group.name
}

data "aws_iam_policy" "sysadmin" {
  arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"

}

data "aws_iam_policy" "monitor" {
  arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"

}
#rds full
data "aws_iam_policy" "db_admin" {
  arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}

resource "aws_iam_group_policy_attachment" "system_adminstrators" {
  group      = aws_iam_group.system_admins.name
  policy_arn = data.aws_iam_policy.sysadmin.arn
}

resource "aws_iam_group_policy_attachment" "database_administrators" {
  group      = aws_iam_group.database_admins.name
  policy_arn = data.aws_iam_policy.db_admin.arn
}
resource "aws_iam_group_policy_attachment" "monitoring_group" {
  group      = aws_iam_group.monitoring_group.name
  policy_arn = data.aws_iam_policy.monitor.arn
}

resource "aws_secretsmanager_secret" "users" {
  name                    = "new_users"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "users" {
  secret_id = aws_secretsmanager_secret.users.id
  secret_string = jsonencode({
    username1 = "${aws_iam_user.users["sysadmin1"].name}"
    password1 = "${aws_iam_user_login_profile.password["sysadmin1"].password}"
    username2 = "${aws_iam_user.users["sysadmin2"].name}"
    password2 = "${aws_iam_user_login_profile.password["sysadmin2"].password}"
    username3 = "${aws_iam_user.users["dbadmin1"].name}"
    password3 = "${aws_iam_user_login_profile.password["dbadmin1"].password}"
    username4 = "${aws_iam_user.users["dbadmin2"].name}"
    password4 = "${aws_iam_user_login_profile.password["dbadmin2"].password}"
    username5 = "${aws_iam_user.users["monitor1"].name}"
    password5 = "${aws_iam_user_login_profile.password["monitor1"].password}"
    username6 = "${aws_iam_user.users["monitor2"].name}"
    password6 = "${aws_iam_user_login_profile.password["monitor2"].password}"
    username7 = "${aws_iam_user.users["monitor3"].name}"
    password7 = "${aws_iam_user_login_profile.password["monitor3"].password}"
    username8 = "${aws_iam_user.users["monitor4"].name}"
    password8 = "${aws_iam_user_login_profile.password["monitor4"].password}"
  })
}

resource "aws_iam_account_password_policy" "password_policy" {
  minimum_password_length      = 8
  hard_expiry                  = var.hard_expiry
  require_lowercase_characters = true
  require_numbers              = true
  require_uppercase_characters = true
  require_symbols              = true
  max_password_age             = var.max_password_age
  password_reuse_prevention    = var.password_reuse_prevention
}