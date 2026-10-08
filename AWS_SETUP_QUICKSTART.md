# AWS quick setup

Run these commands inside the EC2 project directory. Never commit credentials or put them in a tracked file.

```bash
cd K4-L3L4-Track2-Day21-TranCaoThang-2A202602520-CI-CD-for-AI-Systems
source .venv/bin/activate
git pull origin main
pip install -r requirements.txt
export AWS_ACCESS_KEY_ID='YOUR_NEW_ACCESS_KEY'
export AWS_SECRET_ACCESS_KEY='YOUR_NEW_SECRET_KEY'
export AWS_DEFAULT_REGION='ap-southeast-1'
export ARTIFACT_BUCKET='thang-income-mlops-20261007-1234'
python src/train.py
bash scripts/setup_aws_dvc.sh
```

Then open the repository's **Actions** tab and run `Income Model CI/CD` manually. Required repository secrets are:

`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`, `ARTIFACT_BUCKET`, `SERVER_HOST`, `SERVER_USER`, and `SERVER_SSH_KEY`.
