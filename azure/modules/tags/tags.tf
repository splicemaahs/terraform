locals {
  common_tags = tomap({
    "Purpose" = "${var.resource_group}-poc",
    "Department" = var.account,
    "Creator" = var.creator,
    "Date_Created" = formatdate("YYYY-MM-DD'_'hhmm", time_static.date.rfc3339)
  })
}

resource "time_static" "date" {}
