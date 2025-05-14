import boto3

def lambda_handler(event, context):
    ssm_client = boto3.client('ssm', region_name='us-east-1')

    # Pobranie hasła z SSM
    response = ssm_client.get_parameter(Name='/myapplication/db_password', WithDecryption=True)
    
    db_password = response['Parameter']['Value']
    print(f"DB Password: {db_password}")
