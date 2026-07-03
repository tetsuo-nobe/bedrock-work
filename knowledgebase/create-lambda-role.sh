#!/bin/bash
# Lambda 関数の実行ロール (my-Lambda-Bedrock-role) を作成するスクリプト
# CloudShell で実行してください

ROLE_NAME="my-Lambda-Bedrock-role"

# 既にロールが存在するか確認
if aws iam get-role --role-name "${ROLE_NAME}" > /dev/null 2>&1; then
  echo "ロール ${ROLE_NAME} は既に存在します。処理をスキップします。"
  exit 0
fi

# Lambda がこのロールを引き受けるための信頼ポリシー
TRUST_POLICY='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}'

# ロールの作成
echo "IAM ロール ${ROLE_NAME} を作成します..."
aws iam create-role \
  --role-name "${ROLE_NAME}" \
  --assume-role-policy-document "${TRUST_POLICY}" \
  --description "Execution role for Lambda to invoke Bedrock"

# Lambda 基本実行ポリシーのアタッチ（CloudWatch Logs への書き込み用）
echo "Lambda 基本実行ポリシーをアタッチします..."
aws iam attach-role-policy \
  --role-name "${ROLE_NAME}" \
  --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

# Bedrock フルアクセスポリシーのアタッチ
echo "Bedrock フルアクセスポリシーをアタッチします..."
aws iam attach-role-policy \
  --role-name "${ROLE_NAME}" \
  --policy-arn "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"

echo "完了: ロール ${ROLE_NAME} を作成しました。"
