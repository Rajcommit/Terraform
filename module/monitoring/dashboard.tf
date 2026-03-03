# File: /mnt/s/terraform/modules/module/monitoring/dashboard.tf
# Purpose: CloudWatch Dashboard for infrastructure monitoring
# Related: monitoring.tf (alarms), variable.tf (inputs)


##This created the dashboard container
resource "aws_cloudwatch_dashboard" "main" {
    dashboard_name = "${var.project_name}-${var.environment}-dashboard"
    ##Name will be: projectname-environment-dashboard, e.g., myapp-prod-dashboard
       
    ## The dashboard body is defined in JSON format. It specifies the layout and widgets to be displayed on the dashboard.   
    dashboard_body = jsonencode({
        ##Widgets is a list of dashboard widgets. Each widget can display different types of metrics, alarms, or other visualizations. Here we will add a widget to monitor ASG CPU utilization as an example.
        widgets = [
            # Widget #1: ASG CPU Utilization
            {
                type = "metric" ## This widget will display the CPU utilization metric for the Auto Scaling Group (ASG) we are monitoring.
                properties = {
                    # WHAT metric to display
                    metrics = [
                        # Format: [namespace, metric_name, dimension_name, dimension_values, ...]
                        ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name, {
                            stat = "Average"
                            label = "ASG CPU Utilization"
                        }
                        ]
                    ]
                # HOW OFTEN to chcek the metric
                    period = 300 ## 5 minutes
                   
                # What Region to pull the metric from
                    region = "ap-south-1"
                
                # Additional display options for the widget
                    title = "Auto Scaling Group - CPU Usage"

                # Y-AXIS setting (vertical)
                    yAxis = {
                      left = {
                        min = 0 ## CPU utilization cannot be negative
                        max = 100  ## CPU utilization is a percentage, so max is 100%
                        label = "CPU Utilization (%)"
                      }
                    }
                }
             
                # WHERE to place the  the widget on dashboard ( like coordinates on a grid)
                # The dashboard is divided into a grid of 24 columns and 12 rows. The
                # x and y coordinates specify the top-left corner of the widget, while width and height specify how many columns and rows the widget should span.
                width  = 12 # 12 units wide (half the dashboard width)
                height = 6  # 6 units tall
                x = 0       # Start at the leftmost column
                y = 0       # Start at the top row
            }
     # Additional widgets can be added here to monitor other metrics, such as ALB unhealthy hosts, RDS CPU utilization, etc. Each widget would follow a similar structure but with different metrics and properties.
    ]
    })
  }