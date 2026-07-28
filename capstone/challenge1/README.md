# Capstone ハンズオン 課題 1 - サーバーレスの 生成 AI Web アプリケーションの構築

## 概要

* このハンズオンでは、Amazon Bedrock を使用した簡単な生成 AI Web アプリケーションを構築します。ユーザーが Web ページからプロンプトを送信すると、Amazon Bedrock（Amazon Nova Lite v1）が回答を生成して返します。

* 下記の手順で進めてください。

* **課題 のパートでは必要な作業を行って、アプリケーションを完成させてください**

## アーキテクチャ

![](images/overview.png)

### 使用する AWS サービス

| サービス | 用途 |
|---------|------|
| Amazon S3 | Web ページのホスティング（構築済み） |
| Amazon API Gateway | REST API エンドポイント |
| AWS Lambda | バックエンド処理（Python 3.14） |
| Amazon Bedrock | 生成 AI（Amazon Nova Lite v1、クロスリージョン推論） |

## 前提条件

- AWS アカウントを持っていること
- AWS マネジメントコンソールにログインできること
- ハンズオンに必要な操作を許可されていること
- ご自身に割り当てられた ID の値をもっていること

## ハンズオン手順

---

### ステップ 1: Lambda 関数を作成する

1. AWS マネジメントコンソールにログインします
1. 画面右上のリージョン選択で「**米国（オレゴン） us-west-2**」を選択します
1. サービス検索で「**`lambda`**」入力して Lambda のページを開きます
1. 「**関数の作成**」をクリックします
1. 以下の設定で関数を作成します：
    - **(自分のID) の箇所はご自身に割り当てられた ID の値に置き換えてください。**

| 項目 | 値 |
|------|-----|
| 関数名 | `bedrock-genai-function-(自分のID)` |
| ランタイム | Python 3.14 |


1. [**その他の設定**] を展開します。
1. [**カスタム実行ロール**] のトグルを有効化します。
1. [**実行ロール**] で **my-Lambda-Bedrock-role** を選択します。
1. [**保存**] を選択します。
1. ページの下部にある [**関数を作成**] を選択します。

1. 「**Getting started**」のダイアログが表示された場合は 「**Dismiss**」ボタンをクリックして閉じます

---

### ステップ 2: Lambda 関数のコードを記述する

1. Lambda 関数のページに戻り、「**コード**」タブをクリックします
2. `lambda_function.py` の内容をすべて削除し、以下のコードを貼り付けます：
   - 後の課題でコードを修正しますが、ここではそのまま貼り付けてください。

```python
import json
import boto3

# TODO: Bedrock Runtime クライアントを作成


# TODO: 使用するモデル ID（クロスリージョン推論プロファイル）


def lambda_handler(event, context):
    """
    API Gateway から呼び出される Lambda 関数のハンドラー
    ユーザーのプロンプトを受け取り、Bedrock に問い合わせて結果を返す
    """
    try:
        # リクエストボディからプロンプトを取得
        # ユーザーが入力したプロンプトは user_prompt に格納されています。
        body = json.loads(event["body"])
        user_prompt = body["prompt"]

        # TODO: Bedrock Converse API を呼び出す
        

        # TODO: レスポンスからテキストを取得
        # 下記のコードを変更して、result_text に基盤モデルからの回答を格納して下さい。
        result_text = "ダミーの回答"

        # 成功レスポンスを返す
        # 以下のコードは変更しないで下さい。
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

3. 「**Deploy**」ボタンをクリックしてコードをデプロイします

---

### ステップ 3: Lambda 関数のタイムアウトを変更する

Bedrock の応答には時間がかかる場合があるため、タイムアウトを延長します。

1. 「**設定**」タブをクリックします
2. 左側で「**一般設定**」をクリックし、「**編集**」をクリックします
3. タイムアウトを **30 秒** に変更します
4. 「**保存**」をクリックします

---

### ステップ 4: API Gateway の REST API を作成する

1. ページ上部のサービス検索で「**`apigateway`**」入力して API Gateway のページを開きます
1. 「**API の作成**」をクリックします
1. 「**REST API**」の「**構築**」をクリックします（「REST API プライベート」ではありません）
1. 以下の設定で API を作成します。
    -  下表以外の設定はデフォルトのままにしておきます。
   
| 項目 | 値 |
|------|-----|
| API 名 | `bedrock-genai-api-(自分のID)` |
| 説明 | `Bedrock ハンズオンの API` |
| エンドポイントタイプ | リージョン |


1. 「**API を作成**」をクリックします

---

### ステップ 5: API Gateway にリソースとメソッドを作成する

#### リソースの作成

1. 「**リソースを作成**」をクリックします
2. リソース名に `invoke` と入力します
3. 「**CORS (クロスオリジンリソース共有)**」にチェックを入れます
4. 「**リソースを作成**」をクリックします

#### メソッドの作成

1. `/invoke` リソースを選択した状態で「**メソッドを作成**」をクリックします
2. 以下の設定でメソッドを作成します：

| 項目 | 値 |
|------|-----|
| メソッドタイプ | POST |
| 統合タイプ | Lambda 関数 |
| Lambda プロキシ統合 | ✅ 有効にする |
| Lambda 関数 | `bedrock-genai-function-(自分のID)` |

3. 「**メソッドを作成**」をクリックします
4. Lambda 関数に権限を追加するダイアログが表示された場合は「**OK**」をクリックします

---

### ステップ 6: API をデプロイする

1. 「**API をデプロイ**」をクリックします
2. 以下の設定でデプロイします：

| 項目 | 値 |
|------|-----|
| ステージ | *新しいステージ* |
| ステージ名 | `prod` |

3. 「**デプロイ**」をクリックします
4. 表示される「**URL を呼び出す**」の値をコピーします

   例: `https://xxxxxxxxxx.execute-api.us-west-2.amazonaws.com/prod`

> ⚠️ **重要**: この URL は次のステップで使用します。メモ帳などに控えておいてください。

---

### ステップ 7: 動作確認

1. ブラウザで新しいタブを開いて以下の URL にアクセスします：

   `https://tnobep-work-public.s3.ap-northeast-1.amazonaws.com/bedrock-work/index.html`

2. Web ページが表示されたら、以下の操作を行います：
   - 「**API エンドポイント**」欄に、前のステップでコピーした URL の末尾に `/invoke` を追加して入力します
     - 例: `https://xxxxxxxxxx.execute-api.us-west-2.amazonaws.com/prod/invoke`
   - 「**プロンプト**」欄に質問を入力します（例：「日本の首都はどこですか？」）
   - 「**送信**」ボタンをクリックします

3. 数秒後、ページ下部に回答が表示されます 🎉
    - 「**ダミーの回答**」と表示されることを確認してください。


---

### ステップ 8: 課題にチャレンジ

1. Lambda 関数のコードで、「TODO:」部分のコードを完成させて「**Deploy**」をクリックします。

1. その後、ステップ 7 の動作確認手順を行い、基盤モデルからの回答を表示することを確認できれば OK です。

---

## トラブルシューティング

### 「Internal Server Error」が表示される場合

- Lambda 関数のタイムアウトが短すぎないか確認してください（30 秒推奨）
- Lambda 関数の実行ロールに `my-Lambda-Bedrock-role` が付与されているか確認してください
- CloudWatch Logs で Lambda 関数のログを確認してください

### 「CORS エラー」が表示される場合

- API Gateway のリソース作成時に CORS を有効にしたか確認してください
- API を再デプロイしてください

### 回答が返ってこない場合

- Amazon Bedrock のモデルアクセスが有効になっているか確認してください
- API Gateway の URL が正しいか確認してください（末尾に `/invoke` が必要です）

---

## クリーンアップ

ハンズオン終了後、以下のリソースを削除してください：

1. **Lambda 関数**: `bedrock-genai-function` を削除
1. **API Gateway**: `bedrock-genai-api` を削除
1. **CloudWatch ログ**: 「ログ管理」からロググループで「bedrock-genai-function」を含むものを削除
1. **IAM ロール**: Lambda 用に作成されたロールを削除（任意）

---

## 参考リンク

- [Amazon Bedrock ドキュメント](https://docs.aws.amazon.com/bedrock/)
- [Amazon Nova モデル](https://docs.aws.amazon.com/nova/)
- [AWS Lambda ドキュメント](https://docs.aws.amazon.com/lambda/)
- [Amazon API Gateway ドキュメント](https://docs.aws.amazon.com/apigateway/)
