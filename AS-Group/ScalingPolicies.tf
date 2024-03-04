resource "aws_autoscaling_policy" "scale-out" {
    name = "scale-out"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 20
    autoscaling_group_name = aws_autoscaling_group.AS-group.name
}
resource "aws_cloudwatch_metric_alarm" "high-cpu-usage" {
    alarm_name = "high-cpu-usage"
    comparison_operator = "GreaterThanThreshold"
    threshold = 40
    period = 30 //How many seconds until the metric is checked
    evaluation_periods = 1 //How many times the checked metric must exceed threshold to proc
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2" //Which service the metric is associated with
    statistic = "Average"
    alarm_description = "This metric sets off an alarm if CPU usage is over 60% for 120 consecutive seconds"
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.AS-group.name
    }
    alarm_actions = [aws_autoscaling_policy.scale-out.arn]
}

resource "aws_autoscaling_policy" "scale-down" {
    name = "scale-down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 60
    autoscaling_group_name = aws_autoscaling_group.AS-group.name
}

resource "aws_cloudwatch_metric_alarm" "low-cpu-usage" {
    alarm_name = "low-cpu-usage"
    comparison_operator = "LessThanThreshold"
    threshold = 30
    period = 30 //How many seconds until the metric is checked
    evaluation_periods = 2 //How many times the checked metric must exceed threshold to proc
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2" //Which service the metric is associated with
    statistic = "Average"
    alarm_description = "This metric sets off an alarm if CPU usage is over 60% for 120 consecutive seconds"
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.AS-group.name
    }
    alarm_actions = [aws_autoscaling_policy.scale-down.arn]
}