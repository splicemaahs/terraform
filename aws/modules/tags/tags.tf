locals {
  common_tags = map(
    "Purpose", "${var.environment}-poc",
    "Department", var.account,
    "Creator", var.creator,
    "Date_Created", formatdate("YYYY-MM-DD'_'hhmm", time_static.date.rfc3339)
  )
}

resource "time_static" "date" {}
