#!/usr/bin/env bash
set -euo pipefail

: "${ARTIFACT_BUCKET:?Set ARTIFACT_BUCKET before running}"
: "${AWS_DEFAULT_REGION:?Set AWS_DEFAULT_REGION before running}"

echo "[1/6] Checking AWS credentials..."
python -c "import boto3; boto3.client('sts').get_caller_identity(); print('AWS credentials OK')"

echo "[2/6] Initializing DVC..."
if [ ! -d .dvc ]; then
  dvc init
fi

if dvc remote list | grep -q '^labstore'; then
  dvc remote modify labstore url "s3://${ARTIFACT_BUCKET}/dvc"
else
  dvc remote add -d labstore "s3://${ARTIFACT_BUCKET}/dvc"
fi

echo "[3/6] Tracking datasets..."
dvc add data/train_batch1.csv data/holdout.csv data/train_batch2.csv

echo "[4/6] Uploading datasets to S3..."
dvc push

echo "[5/6] Uploading current model to S3..."
python - <<'PY'
import boto3, os
bucket = os.environ["ARTIFACT_BUCKET"]
boto3.client("s3").upload_file("models/model.joblib", bucket, "artifacts/current/model.joblib")
print("Model uploaded")
PY

echo "[6/6] Committing DVC metadata..."
git add .dvc data/*.dvc .gitignore
if ! git diff --cached --quiet; then
  git commit -m "chore: configure DVC and upload model to S3"
  git push origin main
else
  echo "No DVC metadata changes to commit"
fi

echo "DONE: DVC data and model are ready for GitHub Actions."
