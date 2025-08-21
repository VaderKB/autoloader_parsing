#!/bin/bash

image_name=$(jq -r '.ecr.image_name' config.json)
#"snf-atenc-generate-events"
ecr_repo_name=$(jq -r '.ecr.repository_name' config.json)
#"snf-atenc-generate-events-repo"

docker build -t $image_name .

if aws ecr describe-repositories --repository-names $ecr_repo_name --region us-east-1 > /dev/null 2>&1; then
    echo "reposity $ecr_repo_name already present"
else
    echo "creating repo $ecr_repo_name"
    aws ecr create-repository --repository-name $ecr_repo_name --region="us-east-1" --no-cli-pager
fi

# Get creds
aws ecr get-login-password --region "us-east-1" | docker login --username AWS --password-stdin 483151609062.dkr.ecr.us-east-1.amazonaws.com

# Tag image
docker tag $image_name:latest 483151609062.dkr.ecr.us-east-1.amazonaws.com/$ecr_repo_name:latest

# Push image
echo "Pushing image"
docker push 483151609062.dkr.ecr.us-east-1.amazonaws.com/$ecr_repo_name:latest