#!/bin/bash
set -e 

# --- CONFIGURATION ---
# Correct path with Owner/Repo
IMAGE_NAME="ghcr.io/techmaxx-collab/devops-d-techmaxx" 
# --- END CONFIGURATION ---

echo "--- 1. Building Spring Boot App ---"
mvn clean package

echo "--- 2. Generating Image Tag ---"
TAG=$(git rev-parse --short HEAD)
echo "Tag: $TAG"

echo "--- 3. Building Docker Image ---"
docker build -t $IMAGE_NAME:$TAG .
docker build -t $IMAGE_NAME:latest . 

echo "--- 4. Pushing Docker Image to GHCR ---"
docker push $IMAGE_NAME:$TAG
docker push $IMAGE_NAME:latest

echo "--- 5. 🔥 Updating GitOps State ---"
echo "IMAGE_TAG=$TAG" > deploy.config

git add deploy.config

if ! git diff-index --quiet HEAD; then
    git commit -m "AUTO: Update deployment version to $TAG"
    # 🔴 NOTE: Yeh push bhi fail hoga agar permission nahi hai
    git push
    echo "✅ New deployment config pushed to Git."
else
    echo "✅ Deployment config is already up-to-date."
fi

echo "--- CI Script Finished Successfully ---"