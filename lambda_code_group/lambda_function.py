import json
import os
import boto3
import csv
import logging
from collections import defaultdict

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')

S3_BUCKET = os.environ['S3_BUCKET']
S3_KEY = os.environ['S3_KEY']

def lambda_handler(event, context):
    source = event.get("source", "s3")  # domyślnie "s3"
    
    grouped_data = defaultdict(list)
    
    if source == "s3":
        response = s3_client.get_object(Bucket=S3_BUCKET, Key=S3_KEY)
        lines = response["Body"].read().decode("utf-8").splitlines()
        reader = csv.DictReader(lines)
        for row in reader:
            location_id = row.get("location_id")
            if location_id:
                grouped_data[location_id].append(row)
        logger.info("Pobrano dane z S3 i pogrupowano po location_id.")
    else:
        logger.error("Nieobsługiwane źródło: %s", source)
        raise ValueError("Nieobsługiwane źródło danych.")

    # Przekształć dane do listy gotowej do `Parallel` w Step Functions
    parallel_inputs = []
    for location_id, records in grouped_data.items():
        parallel_inputs.append({
            "group_id": location_id,
            "data": records
        })

    return {
        "parallel_inputs": parallel_inputs
    }