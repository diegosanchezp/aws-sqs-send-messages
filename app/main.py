import logging

import boto3

# Initialize the logger
logger = logging.getLogger()
logger.setLevel("INFO")


# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
def lambda_handler(event, context):
    logger.info(f"boto3 version: {boto3.__version__}")
    for message in event["Records"]:
        process_message(message)
    print("done")


def process_message(message):
    try:
        print(f"Processed message {message['body']}")
        # TODO: Do interesting work based on the new message
    except Exception as err:
        print("An error occurred")
        raise err
