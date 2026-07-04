# Capstone ハンズオン 課題 2 - サーバーレスの RAG アプリケーションの構築

## 概要

* このハンズオンでは、Amazon Bedrock のナレッジベースを使用した RAG（Retrieval-Augmented Generation）Web アプリケーションを構築します。ユーザーが Web ページからプロンプトを送信すると、ナレッジベースに登録されたドキュメントを検索し、その内容をもとに回答を生成して返します。

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
| Amazon Bedrock ナレッジベース | RAG による回答生成 |


## 前提条件

- AWS アカウントを持っていること
- AWS マネジメントコンソールにログインできること
- ハンズオンに必要な操作を許可されていること
- ご自身に割り当てられた ID の値をもっていること

## ハンズオン手順

---
### ステップ 1: Amazon S3 バケットの作成と PDF ファイルの格納

1. 下記リンクを右クリックして、リンク先保存を選択して **AnyCompany_IR.pdf** をダウンロードして下さい。
    - (https://dl39k3l39to9h.cloudfront.net/pdfs/AnyCompany_IR.pdf)
    - この PDF は架空の会社 AnyCompany 決算説明資料です。

1. AWS マネジメントコンソールにログインします
1. 画面右上のリージョン選択で「**米国西部（オレゴン） us-west-2**」を選択します
1. AWS マネジメントコンソールのページ上部の **検索**で `s3` と入力して **S3** のメニューを選択します。
1. [**バケットを作成**] を選択します。
1. [**バケット名**] は下記のようにしてしてください。
    - **(自分のID) の部分はご自身に割り当てられた ID の値に置き換えてください**
    - ```
      tnobect-0730-challenge2-(自分のID)
      ```
    - 例: tnobect-0730-challenge2-99
1. ページを下までスクロールして [**バケットを作成**] を選択します。    
1. [**アップロード**] をクリックします。
1. [**ファイルを追加**] をクリックしてダウンロードしていた **AnyCompany_IR.pdf** を指定します。
1. [**アップロード**]　を選択します。
1. [**閉じる**]　を選択します。

---
### ステップ 2: Amazon Bedrock ナレッジベースの作成

#### ナレッジベース名

1. AWS マネジメントコンソールのページ上部の **検索**で `bedrock` と入力して **Amazon Bedrock** のメニューを選択します。
1. ページ左側で [**構築**] の [**ナレッジベース**] を選択します。
1. [**Create Managed KB**] から [**Unstructured Vector Store KB**] を選択します。
1. [**ナレッジベース名**] に下記を入力します。
    - **(自分のID) の部分はご自身に割り当てられた ID の値に置き換えてください**
    - ```
      challenge2-kb-(自分のID)
      ``` 
1. [**IAM 許可**] の [**ランタイムロール**] で [**新しいサービスロールを作成して使用**] を選択します。
1. [**サービスロール名**]　はデフォルトのままにしておきます。

#### データソースの指定

1. [**データソースの選択**] で **Amazon S3** を選択します。
1. [**次へ**] を選択します。
1. [**データソース名**] に下記を入力します。
    - ```
      challenge2-kb-ds
      ```
1. [**S3 の URI**] で [**S3 を参照**] を選択します。
1. 作成した S3 バケット名のラジオボタンを選択して、[**選択**] を選択します。
1. その他はすべてデフォルトのままにして [**次へ**] を選択します。

#### 埋め込みモデルの指定

1. [**埋め込みモデル**] で [**モデルを選択**] を選択します。
1. [**Amazon**] の [**Titan Embneddings V2**] を選択します。
1. [**適用**] を選択します。

#### ベクトルデータベースの指定

1. [**ベクトルデータベース**]　セクションを表示します。 
1. [**ベクトルストアの作成方法**] で [**新しいベクトルストアをクイック作成**] を選択します。
1. [**ベクトルストア**] で [**Amazon S3 Vectors**] を選択します。
1. [**次へ**] を選択します。
1. ページを下にスクロールして [**ナレッジベースを作成**] をクリックします。
1. 作成が完了するまで数分待ちます。

#### データソースの同期

1. 作成したナレッジベースのページで [**データソース**] のセクションを表示します。
1. [**challenge2-kb-ds**] のチェックボックスをチェックして [**同期**] を選択します。
1. ページ上部に緑色で同期の完了メッセージが出るまで待ちます。

#### ナレッジベースのテスト

1. [**ナレッジベースをテスト**] を選択します。
1. [**モデルを選択**] を選択します。
1. [**Amazon**] の [**Nova Lite**] を選択して [**適用**] を選択します。
1. ページ下側で下記のプロンプトを入力します。
    - ```
      AnyCompany社の2025年3月期 第1四半期の営業利益を教えてください。
      ```
1. Enter キーで送信します。
1. モデルからの回答を確認します。**304百万円** と出力されるはずです。
1. 他にも下記のようなプロンプトを試してみましょう
    - ```
      AnyCompany社の顧客数を教えてください。
      ```
      - **308社** と出力されるはずです。

---

### ステップ 3: ナレッジベースの ID を確認する

1. 左メニューから「**ナレッジベース**」をクリックします
1. 使用するナレッジベースの名前をクリックします
1. 「**ナレッジベースの概要**」セクションに表示されている「**ナレッジベース ID**」をコピーします

> ⚠️ **重要**: この ID は後のステップで Lambda 関数のコードに設定します。メモ帳などに控えておいてください。
---

### ステップ 4: Lambda 関数を作成する

1. サービス検索で「**`lambda`**」入力して Lambda のページを開きます
1. 「**関数を作成**」または 「**関数の作成**」をクリックします
1. 以下の設定で関数を作成します：
    - **(自分のID) の箇所はご自身に割り当てられた ID の値に置き換えてください。**

| 項目 | 値 |
|------|-----|
| 関数名 | `bedrock-rag-function-(自分のID)` |
| ランタイム | Python 3.14 |


1. [**その他の設定**] を展開します。
1. [**カスタム実行ロール**] のトグルを有効化します。
1. [**実行ロール**] で **my-Lambda-Bedrock-role** を選択します。
1. [**保存**] を選択します。
1. ページの下部にある [**関数を作成**] を選択します。

1. 「**Getting started**」のダイアログが表示された場合は 「**Dismiss**」ボタンをクリックして閉じます

---

### ステップ 5: Lambda 関数のコードを記述する

1. Lambda 関数のページに戻り、「**コード**」タブをクリックします
2. `lambda_function.py` の内容をすべて削除し、以下のコードを貼り付けます：
   - 後の課題でコードを修正しますが、ここではそのまま貼り付けてください。

```python
import json
import boto3

# TODO: Bedrock Agent Runtime クライアントを作成


# TODO: ナレッジベース ID（前のステップで確認した ID に置き換えてください）
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
        # ユーザーが入力したプロンプトは user_prompt に格納されています。
 
        body = json.loads(event["body"])
        user_prompt = body["prompt"]

        # TODO: Bedrock RetrieveAndGenerate API を呼び出す


        # TODO: レスポンスからテキストを取得
        # 下記のコードを変更して、result_text に基盤モデルからの回答を格納して下さい。
        result_text = "ダミーの回答"

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

3. 「**Deploy**」ボタンをクリックしてコードをデプロイします

---

### ステップ 6: Lambda 関数のタイムアウトを変更する

Bedrock の応答には時間がかかる場合があるため、タイムアウトを延長します。

1. 「**設定**」タブをクリックします
2. 左側で「**一般設定**」をクリックし、「**編集**」をクリックします
3. タイムアウトを **30 秒** に変更します
4. 「**保存**」をクリックします

---

### ステップ 7: API Gateway の REST API を作成する

1. ページ上部のサービス検索で「**`apigateway`**」入力して API Gateway のページを開きます
1. 「**API の作成**」をクリックします
1. 「**REST API**」の「**構築**」をクリックします（「REST API プライベート」ではありません）
1. 以下の設定で API を作成します。
    -  下表以外の設定はデフォルトのままにしておきます。
   
| 項目 | 値 |
|------|-----|
| API 名 | `bedrock-rag-api-(自分のID)` |
| 説明 | `Bedrock ナレッジベースハンズオンの API` |
| エンドポイントタイプ | リージョン |


1. 「**API を作成**」をクリックします

---

### ステップ 8: API Gateway にリソースとメソッドを作成する

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
| Lambda 関数 | `bedrock-rag-function-(自分のID)` |

3. 「**メソッドを作成**」をクリックします
4. Lambda 関数に権限を追加するダイアログが表示された場合は「**OK**」をクリックします

---

### ステップ 9: API をデプロイする

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

### ステップ 10: 動作確認

1. ブラウザで新しいタブを開いて以下の URL にアクセスします：

   `https://tnobep-work-public.s3.ap-northeast-1.amazonaws.com/bedrock-work/index.html`

2. Web ページが表示されたら、以下の操作を行います：
   - 「**API エンドポイント**」欄に、前のステップでコピーした URL の末尾に `/invoke` を追加して入力します
     - 例: `https://xxxxxxxxxx.execute-api.us-west-2.amazonaws.com/prod/invoke`
     - 「**プロンプト**」欄にナレッジベースに登録したドキュメントに関する質問を入力します
       - 例：
       - ```
         AnyCompany社の2025年3月期 第1四半期の営業利益を教えてください。
         ```
   - 「**送信**」ボタンをクリックします

3. 数秒後、ページ下部に回答が表示されます 🎉
    - 「**ダミーの回答**」と表示されることを確認してください。

---

### 課題

* Lambda 関数のコードを変更して、RetrieveAndGenerate API でナレッジベースに問い合わせを行う処理を完成して下さい。
    - コード内の変数 `model_arn` にモデル ARN が格納済みです。これを使用して下さい。
    - `KNOWLEDGE_BASE_ID` にはメモしておいたナレッジベース ID を設定して下さい。
    - コードを変更後は、「**Deploy**」をクリックしてください。 

* コード修正後、前のステップの動作確認を行いナレッジベースを正しく呼び出せていることを確認してください。

       - 例：
       - ```
         AnyCompany社の2025年3月期 第1四半期の営業利益を教えてください。
         ```
       - ```
         AnyCompany社の顧客数を教えてください。
         ```

* 解答例は solution フォルダの README.md を参照して下さい。
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

1. **Lambda 関数**: `bedrock-rag-function-(自分のID)` を削除
1. **API Gateway**: `bedrock-rag-api-(自分のID)` を削除
1. **CloudWatch ログ**: 「ログ管理」からロググループで「bedrock-rag-function」を含むものを削除
1. **IAM ロール**: Lambda 用に作成されたロールを削除（任意）

---

## 参考リンク

- [Amazon Bedrock ナレッジベース ドキュメント](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html)
- [RetrieveAndGenerate API リファレンス](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_RetrieveAndGenerate.html)
- [AWS Lambda ドキュメント](https://docs.aws.amazon.com/lambda/)
- [Amazon API Gateway ドキュメント](https://docs.aws.amazon.com/apigateway/)
