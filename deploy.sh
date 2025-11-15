#!/bin/bash
set -e

# --- CONFIGURATION ---
IMAGE_REPO="ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME"
CONTAINER_NAME="my-gitops-app" # Running container ka naam
# --- END CONFIGURATION ---

echo "--- 1. Fetching Latest 'Desired State' from Git ---"
git pull

echo "--- 2. Reading Deployment Config ---"
# deploy.config file se version load karega
if [ ! -f deploy.config ]; then
    echo "ERROR: deploy.config not found!"
    exit 1
fi
source deploy.config # Yeh 'IMAGE_TAG' variable ko script mein load karega
echo "Desired version (from Git) is: $IMAGE_TAG"

echo "--- 3. Pulling Correct Image from GHCR ---"
docker pull $IMAGE_REPO:$IMAGE_TAG

echo "--- 4. Reconciling Environment (Stopping old container) ---"
# '|| true' taaki agar container na bhi ho toh error na aaye
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

echo "--- 5. Deploying New Version ---"
docker run -d -p 8080:8080 --name $CONTAINER_NAME $IMAGE_REPO:$IMAGE_TAG

echo "--- ✅ Deployment Successful! ---"
echo "App '$CONTAINER_NAME' is running version $IMAGE_TAG."
echo "Check at: http://localhost:8080/hello"