#!/bin/bash

log_info() {
    printf "%s\n" "$*"
}

PACKAGES_DIR=packages
ZIP_FILE=package.zip

[ -d "$PACKAGES_DIR" ] && rm -r "$PACKAGES_DIR" && log_info "Directory $PACKAGES_DIR was removed"
[ -f "$ZIP_FILE" ] && rm "$ZIP_FILE" && log_info "Removed file: $ZIP_FILE"

uv export --frozen --no-dev --no-editable -o requirements.txt && \

uv pip install \
 --no-installer-metadata \
 --no-compile-bytecode \
 --python-platform x86_64-manylinux2014 \
 --python 3.13 \
 --target $PACKAGES_DIR \
 -r requirements.txt

cd packages || exit
zip -r ../$ZIP_FILE .
cd ..
zip -r $ZIP_FILE app && echo "" && log_info "Showing $ZIP_FILE structure:"
unzip -l $ZIP_FILE

# Ask user if they want to upload to S3 bucket
read -p "Upload code to s3 bucket? [y/n] " -n 1 -r
echo    # move to a new line

if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Uploading to S3 bucket..."
    BUCKET_NAME=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" --output text)

    aws s3 cp $ZIP_FILE s3://$BUCKET_NAME/lambda-code/$ZIP_FILE
    aws lambda update-function-code \
   --function-name read-sqs \
   --zip-file fileb://$ZIP_FILE
else
    echo "Skipping S3 upload."
fi
