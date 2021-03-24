import boto3
import os

mediaconvert_client = boto3.client('mediaconvert', endpoint_url=os.environ['MEDIACONVERT_ENDPOINT'])


def lambda_audio_converter(event, context):
    s3_bucket_name = event['Records'][0]['s3']['bucket']['name']
    s3_object_key = event['Records'][0]['s3']['object']['key']

    response = mediaconvert_client.get_job_template(
        Name=os.environ['MEDIACONVERT_AUDIO_TEMPLATE_NAME']
    )
    job_settings = response['JobTemplate']

    print(job_settings)

