import os
import boto3 # type: ignore

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    efs_path = os.environ['EFS_PATH']
    backup_bucket = os.environ['BACKUP_BUCKET']

    for root, dirs, files in os.walk(efs_path):
        for file in files:
            file_path = os.path.join(root, file)
            s3_key = os.path.relpath(file_path, efs_path)  # Preserve the directory structure in S3
            
            try:
                s3_client.upload_file(file_path, backup_bucket, s3_key)
                print(f'Successfully uploaded {file_path} to s3://{backup_bucket}/{s3_key}')
            except Exception as e:
                print(f'Error uploading {file_path}: {e}')