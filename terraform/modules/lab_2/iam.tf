data "aws_iam_policy_document" "sqs_publish" {
  statement {
    effect = "Allow"
    actions = ["sqs:SendMessage", "sqs:SendMessageBatch"]
    resources = [aws_sqs_queue.dollar.arn]
    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_sqs_queue_policy" "coin_sorter_policy" {
  queue_url = aws_sqs_queue.dollar.id
  policy = data.aws_iam_policy_document.sqs_publish.json
}