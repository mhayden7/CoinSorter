data "aws_iam_policy_document" "sqs_publish" {
  for_each = toset(var.coin_types)

  statement {
    effect = "Allow"
    actions = ["sqs:SendMessage", "sqs:SendMessageBatch"]
    resources = [aws_sqs_queue.coin[each.value].arn]

    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_sqs_queue_policy" "coin_sorter_policy" {
  for_each = toset(var.coin_types)
  
  queue_url = aws_sqs_queue.coin[each.value].id
  policy = data.aws_iam_policy_document.sqs_publish[each.value].json
}