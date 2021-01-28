# Send/receive SMS via AWS SNS & Pinpoint

Setup:
+ Move sms folder to the server
+ Use sms.sql to create sms table
+ Add endpoint to Amazon SNS -> Topics -> receivesms -> Create Subscription (button) ->
  Protocol: HTTPS -> Endpoint: https://server.url/sms/register
+ Pinpoint -> Settings -> Request long codes
+ To change api keys run: aws configure

Requires permissions:
+ SNSfull control policy
+ mobileanalytics and mobilehub full access
+ mobiletargeting:GetApps
+ ses:GetAccount
+ ses:ListEmailIdentities
+ cloudwatch:ListMetrics
+ kms:DescribeKey
