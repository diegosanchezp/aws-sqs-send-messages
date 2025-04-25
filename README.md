
Tutorials to follow:
- [Send Messages Between Distributed Applications with Amazon Simple Queue Service (SQS)](https://aws.amazon.com/getting-started/hands-on/send-messages-distributed-applications/?ref=gsrchandson)
- [Tutorial: Using Lambda with Amazon SQS - AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/with-sqs-example.html)

Cloudformation template and lambda python code

# Deployment

TODO: 
- [ ] Refactor with SAM to avoid commenting out resources

Set needed environment variables to avoid repetition

```bash
export STACK_NAME=LambdaSQSStack
export TEMPLATE_BODY=lambda_template.yaml
```

Deploy using cloudformation

First, comment out the lambda resources

```diff
diff --git a/lambda_template.yaml b/lambda_template.yaml
index eaba4f0..7cbf9fd 100644
-  ReadSQSLambdaFunction:
-    Type: AWS::Lambda::Function
-    Properties:
-      FunctionName: read-sqs
-      Runtime: python3.13
-      Code:
-        S3Bucket: !Ref LambdaBucket       # <-- Your S3 bucket name
-        S3Key: lambda-code/package.zip  # <-- Path to your ZIP file
-      Handler: app.main.lambda_handler
-      Role: !GetAtt LambdaExecutionRole.Arn
+  # ReadSQSLambdaFunction:
+  #   Type: AWS::Lambda::Function
+  #   Properties:
+  #     FunctionName: read-sqs
+  #     Runtime: python3.13
+  #     Code:
+  #       S3Bucket: !Ref LambdaBucket       # <-- Your S3 bucket name
+  #       S3Key: lambda-code/package.zip  # <-- Path to your ZIP file
+  #     Handler: app.main.lambda_handler
+  #     Role: !GetAtt LambdaExecutionRole.Arn
 
-  LambdaEventSourceMapping:
-    Type: AWS::Lambda::EventSourceMapping
-    Properties:
-      BatchSize: 10
-      EventSourceArn: !GetAtt Queue.Arn
-      FunctionName: !GetAtt ReadSQSLambdaFunction.Arn
-      Enabled: true
+  # LambdaEventSourceMapping:
+  #   Type: AWS::Lambda::EventSourceMapping
+  #   Properties:
+  #     BatchSize: 10
+  #     EventSourceArn: !GetAtt Queue.Arn
+  #     FunctionName: !GetAtt ReadSQSLambdaFunction.Arn
+  #     Enabled: true
```

This will create the S3 Bucket and the Queue

```bash
aws cloudformation deploy --no-execute-changeset --capabilities CAPABILITY_NAMED_IAM --stack-name $STACK_NAME --template-file $TEMPLATE_BODY
```

Then uncomment and deploy back again to create the Lambda and the EventSourceMapping resources.
