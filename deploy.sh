#!/bin/bash
set -e

# --- CONFIGURATION ---
# Correct path with Owner/Repo
IMAGE_REPO="ghcr.io/techmaxx-collab/devops-d-techmaxx"
CONTAINER_NAME="my-gitops-app" 
# --- END CONFIGURATION ---

echo "--- 1. Fetching Latest 'Desired State' from Git ---"
# 🔴 NOTE: Yeh pull bhi fail hoga agar permission nahi hai
git pull

echo "--- 2. Reading Deployment Config ---"
if [ ! -f deploy.config ]; then
    echo "ERROR: deploy.config not found!"
    exit 1
fi
source deploy.config 
echo "Desired version (from Git) is: $IMAGE_TAG"

echo "--- 3. Pulling Correct Image from GHCR ---"
docker pull $IMAGE_REPO:$IMAGE_TAG

echo "--- 4. Reconciling Environment (Stopping old container) ---"
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

echo "--- 5. Deploying New Version ---"
docker run -d -p 8080:8080 --name $CONTAINER_NAME $IMAGE_REPO:$IMAGE_TAG

echo "--- ✅ Deployment Successful! ---"
echo "App '$CONTAINER_NAME' is running version $IMAGE_TAG."
echo "Check at: http://localhost:8080/hello"