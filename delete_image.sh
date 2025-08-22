#!/bin/bash

ecr_repo_name=$(jq -r '.ecr.repository_name' config.json)
aws ecr delete-repository --repository-name $ecr_repo_name --region us-east-1 --force
