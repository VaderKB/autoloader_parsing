import boto3
import json
import random
import hashlib
from datetime import datetime
import time

s3 = boto3.client("s3")

# Buckets and paths
data_bucket = "snowflake-user-data-vader-k"
metadata_bucket = "snowflake-user-data-vader-k"
data_prefix = "autoloading_project/data/"
metadata_prefix = "autoloading_project/loggers/"

def generate_id():
    """Generate unique ID based on timestamp (including ms)."""
    return datetime.utcnow().strftime("%Y%m%d%H%M%S%f")

def generate_hash_id():
    """Generate random hash ID for each reading."""
    return hashlib.md5(str(time.time_ns()).encode()).hexdigest()[:16]

def generate_reading():
    """Generate a reading with all sensors."""
    return {
        "id": generate_hash_id(),
        "readings": [
        {"temperature": round(random.uniform(-10, 40), 2)},  # Celsius
        {"humidity": round(random.uniform(20, 100), 2)},    # %
        {"pressure": round(random.uniform(950, 1050), 2)},  # hPa
        {"light": round(random.uniform(0, 1000), 2)},       # lumens
        {"co2": round(random.uniform(300, 2000), 2)} 
              ],      # ppm
        "timestamp": datetime.utcnow().isoformat()
    }

def create_data_file(num_readings=200):
    """Create a JSON data file with multiple readings."""
    readings = [generate_reading() for _ in range(num_readings)]
    return readings

def lambda_handler(event, context):
    # Generate unique ID for file
    file_id = generate_id()

    # Create data file with 200–1000 readings
    num_readings = random.randint(200, 1000)
    data = create_data_file(num_readings)

    # Define file paths
    data_file_key = f"{data_prefix}{file_id}.json"
    metadata_file_key = f"{metadata_prefix}{file_id}_metadata.json"

    # Upload data file to S3
    s3.put_object(
        Bucket=data_bucket,
        Key=data_file_key,
        Body=json.dumps(data, indent=2)
    )

    # Create metadata JSON
    metadata = {
        "id": file_id,
        "path": f"s3://{data_bucket}/{data_file_key}",
        "count": len(data)
    }

    # Upload metadata file to S3
    s3.put_object(
        Bucket=metadata_bucket,
        Key=metadata_file_key,
        Body=json.dumps(metadata, indent=2)
    )

    print("Data file path:", metadata["path"])
    print("Count:", metadata["count"])
    print("Metadata file:", f"s3://{metadata_bucket}/{metadata_file_key}")
