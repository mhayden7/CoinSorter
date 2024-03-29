resource "aws_sqs_queue" "dollar" {
  name = "dollar"
}

resource "aws_cloudwatch_event_rule" "dollar" {
  name = "dollar_event_rule"
  event_bus_name = var.event_bus_name
  event_pattern = jsonencode({"detail": {"type": [{"equals-ignore-case": "dollar"}]}})
}

resource "aws_cloudwatch_event_target" "sqs_dollar" {
  rule = aws_cloudwatch_event_rule.dollar.name
  arn = aws_sqs_queue.dollar.arn
  event_bus_name = var.event_bus_name
}