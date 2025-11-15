#!/bin/bash
set -e # Koi bhi command fail ho toh script ruk jayegi

# --- CONFIGURATION ---
# Yeh small letter mein hona chahiye
IMAGE_NAME="ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME" 
# --- END CONFIGURATION ---

echo "--- 1. Building Spring Boot App ---"
mvn clean package

echo "--- 2. Generating Image Tag ---"
# Hum git ke short hash ko as version use karenge (e.g., a1b2c3d)
TAG=$(git rev-parse --short HEAD)
echo "Tag: $TAG"

echo "--- 3. Building Docker Image ---"
docker build -t $IMAGE_NAME:$TAG .
docker build -t $IMAGE_NAME:latest . # latest tag bhi update kar dete hain

echo "--- 4. Pushing Docker Image to GHCR ---"
docker push $IMAGE_NAME:$TAG
docker push $IMAGE_NAME:latest

echo "--- 5. 🔥 Updating GitOps State ---"
# YEH HAI GITOPS KA MAIN STEP!
# Hum Git mein ek file update kar rahe hain taaki "deploy" script ko pata chale
# ki kaunsa version deploy karna hai.
echo "IMAGE_TAG=$TAG" > deploy.config

git add deploy.config
# Check karte hain agar kuch commit karne ko hai (ho sakta hai tag same ho)
if ! git diff-index --quiet HEAD; then
    git commit -m "AUTO: Update deployment version to $TAG"
    git push
    echo "✅ New deployment config pushed to Git."
else
    echo "✅ Deployment config is already up-to-date."
fi

echo "--- CI Script Finished Successfully ---"