resource "aws_cloudwatch_event_bus" "coin_sorter" {
  name = "coin_sorter"
}

resource "aws_cloudwatch_event_archive" "coin_sorter_archive" {
  count = var.region == "primary" ? 1 : 0

  name = "coin_sorter_archive"
  event_source_arn = aws_cloudwatch_event_bus.coin_sorter.arn
}

resource "aws_sqs_queue" "coin" {
  for_each = toset(var.coin_types)

  name = "${each.value}"
}

resource "aws_cloudwatch_event_rule" "event_rule"{
  for_each = toset(var.coin_types)

  name = "${each.value}_event_rule"
  event_bus_name = aws_cloudwatch_event_bus.coin_sorter.name
  event_pattern = jsonencode({"detail": {"type": [{"equals-ignore-case": "${each.value}"}]}})
}

resource "aws_cloudwatch_event_target" "sqs_coin" {
  for_each = toset(var.coin_types)

  rule = aws_cloudwatch_event_rule.event_rule[each.value].name
  arn = aws_sqs_queue.coin[each.value].arn
  event_bus_name = aws_cloudwatch_event_bus.coin_sorter.name
}