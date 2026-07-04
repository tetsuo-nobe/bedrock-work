# Capstone ハンズオン 課題1 - 解答例

## Lambda 関数のコード（解答例）

以下は、課題1 の TODO 部分を完成させた Lambda 関数のコードです。

```python
import json
import boto3

# Bedrock Runtime クライアントを作成
bedrock_runtime = boto3.client("bedrock-runtime")

# 使用するモデル ID（クロスリージョン推論プロファイル）
MODEL_ID = "us.amazon.nova-lite-v1:0"


def lambda_handler(event, context):
    """
    API Gateway から呼び出される Lambda 関数のハンドラー
    ユーザーのプロンプトを受け取り、Bedrock に問い合わせて結果を返す
    """
    try:
        # リクエストボディからプロンプトを取得
        body = json.loads(event["body"])
        user_prompt = body["prompt"]

        # Bedrock Converse API を呼び出す
        response = bedrock_runtime.converse(
            modelId=MODEL_ID,
            messages=[
                {
                    "role": "user",
                    "content": [
                        {
                            "text": user_prompt
                        }
                    ]
                }
            ]
        )

        # レスポンスからテキストを取得
        result_text = response["output"]["message"]["content"][0]["text"]

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

### 1. Bedrock Runtime クライアントの作成

```python
bedrock_runtime = boto3.client("bedrock-runtime")
```

- `boto3.client("bedrock-runtime")` で Bedrock Runtime のクライアントを作成します。
- ハンドラ関数の外に配置することで、Lambda のウォームスタート時にクライアントの再生成を避けます。

### 2. モデル ID の指定

```python
MODEL_ID = "us.amazon.nova-lite-v1:0"
```

- クロスリージョン推論プロファイルのモデル ID を指定します。

### 3. Converse API の呼び出し

```python
response = bedrock_runtime.converse(
    modelId=MODEL_ID,
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "text": user_prompt
                }
            ]
        }
    ]
)
```

- `converse` API にモデル ID とメッセージを渡して呼び出します。
- `messages` はチャット形式で、`role` に `"user"` を指定し、`content` にユーザーのプロンプトを含めます。

### 4. レスポンスからテキストを取得

```python
result_text = response["output"]["message"]["content"][0]["text"]
```

- Converse API のレスポンスから、モデルが生成したテキストを取得します。
