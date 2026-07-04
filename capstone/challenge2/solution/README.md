# Capstone ハンズオン 課題2 - 解答例

## Lambda 関数のコード（解答例）

以下は、課題2 の TODO 部分を完成させた Lambda 関数のコードです。

```python
import json
import boto3

# Bedrock Agent Runtime クライアントを作成
bedrock_agent_runtime = boto3.client("bedrock-agent-runtime")

# ナレッジベース ID（前のステップで確認した ID に置き換えてください）
KNOWLEDGE_BASE_ID = "ここにナレッジベース ID を入力"


def lambda_handler(event, context):
    """
    API Gateway から呼び出される Lambda 関数のハンドラー
    ユーザーのプロンプトを受け取り、ナレッジベースに問い合わせて結果を返す
    """
    try:
        # Lambda 関数の ARN からアカウント ID を取得
        account_id = context.invoked_function_arn.split(":")[4]

        # 使用するモデル ARN（クロスリージョン推論プロファイル）
        model_arn = f"arn:aws:bedrock:us-west-2:{account_id}:inference-profile/us.amazon.nova-lite-v1:0"

        # リクエストボディからプロンプトを取得
        body = json.loads(event["body"])
        user_prompt = body["prompt"]

        # Bedrock RetrieveAndGenerate API を呼び出す
        response = bedrock_agent_runtime.retrieve_and_generate(
            input={"text": user_prompt},
            retrieveAndGenerateConfiguration={
                "type": "KNOWLEDGE_BASE",
                "knowledgeBaseConfiguration": {
                    "knowledgeBaseId": KNOWLEDGE_BASE_ID,
                    "modelArn": model_arn
                }
            }
        )

        # レスポンスからテキストを取得
        result_text = response["output"]["text"]

        # 成功レスポンスを返す
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST, OPTIONS"
            },
            "body": json.dumps({
                "response": result_text
            }, ensure_ascii=False)
        }

    except Exception as e:
        # エラーレスポンスを返す
        print(f"エラーが発生しました: {str(e)}")
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST, OPTIONS"
            },
            "body": json.dumps({
                "error": "内部エラーが発生しました。"
            }, ensure_ascii=False)
        }
```

## 解説

課題テンプレートの TODO コメントに対応する実装は以下の通りです。

### 1. Bedrock Agent Runtime クライアントの作成

```python
bedrock_agent_runtime = boto3.client("bedrock-agent-runtime")
```

- ナレッジベースの RetrieveAndGenerate API を使用するには `bedrock-agent-runtime` クライアントが必要です。
- 課題1 で使用した `bedrock-runtime`（Converse API 用）とは異なるクライアントです。
- ハンドラ関数の外に配置することで、Lambda のウォームスタート時にクライアントの再生成を避けます。

### 2. RetrieveAndGenerate API の呼び出し

```python
response = bedrock_agent_runtime.retrieve_and_generate(
    input={"text": user_prompt},
    retrieveAndGenerateConfiguration={
        "type": "KNOWLEDGE_BASE",
        "knowledgeBaseConfiguration": {
            "knowledgeBaseId": KNOWLEDGE_BASE_ID,
            "modelArn": model_arn
        }
    }
)
```

- `retrieve_and_generate` API にプロンプトとナレッジベースの設定を渡して呼び出します。
- `type` には `"KNOWLEDGE_BASE"` を指定します。
- `knowledgeBaseId` には事前にメモしたナレッジベース ID を設定します。
- `modelArn` には回答生成に使用するモデルの ARN を指定します。

### 3. レスポンスからテキストを取得

```python
result_text = response["output"]["text"]
```

- RetrieveAndGenerate API のレスポンス構造は Converse API とは異なります。
- `response["output"]["text"]` でナレッジベースの検索結果をもとに生成された回答テキストを取得します。
