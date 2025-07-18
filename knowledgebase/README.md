# Amazon Bedrock のナレッジベースを作成してみよう

* このワークでは、Amazon Bedrock のナレッジベースを作成します。
* 架空の会社 AnyCompany の休暇規定の PDF ファイルを Amazon S3 バケットに格納しデータソースとします。
* Embed モデルとして Amazon Titan Text Embeddings v2 を使用します。
* ベクトルデータベースとして Amazon OpenSearch Serverless を使用します。
* 作成したナレッジベースは、AWS マネジメントコンソールのテスト機能から動作確認を行います。

![概要](images/overview.png)

---
## 準備

* インストラクターが指定した環境で AWS マネジメントコンソールにサインインして下さい。
    - **このワークの環境は、ワークを実施する時間帯のみ使用可能です。**
* AWS マネジメントコンソールで、**指定されたリージョン**を選択した状態にしてください。
* ご自分に割り当てられた **2桁の番号**を覚えておいてください。
* 下記をクリックして、Download Raw file アイコンから **AnyCompany.pdf** をダウンロードして下さい。
    - (https://github.com/tetsuo-nobe/bedrock-work/blob/main/knowledgebase/AnyCompany.pdf)
    - この PDF は架空の会社 AnyCompany の休暇規定です。

---
## Amazon S3 バケットの作成と PDF ファイルの格納

1. AWS マネジメントコンソールのページ上部の **検索**で `s3` と入力して **S3** のメニューを選択します。
1. **バケットを作成**　を選択します。
1. **バケット名**は下記のようにしてしてください。
    - `tnobect-bedrock-work-kb-ご自分の番号`
    - 例: tnobect-bedrock-work-kb-99
1. ページを下までスクロールして **バケットを作成** を選択します。    
1. 汎用バケットの一覧表示で、作成したバケットの名前のリンクを選択します。
1. **アップロード** をクリックします。
1. **ファイルを追加** をクリックしてダウンロードしていた **AnyCompany.pdf** を指定します。
1. **アップロード**　を選択します。
1. **閉じる**　を選択します。


---
## 基盤モデルのアクセスの有効化

1. AWS マネジメントコンソールのページ上部の **検索**で `bedrock` と入力して **Amazon Bedrock** のメニューを選択します。
1. ページ左側で **Bedrock configurations** の **モデルアクセス** を選択します。
1. **特定のモデルを有効にする** を選択します。
    - もしくは **モデルアクセスを変更** を選択します。
1. 下記のモデルのチェックボックスをチェックします。（すでにチェックされている場合はナレッジベース作成手順に進んでください）
    - **Amazon** の **Titan Text Embeddings V2** 
    - **Amazon** の **Nova Lite**
1. **次へ**　を選択します。
1. **送信**　を選択します。

---
## Amazon Bedrock ナレッジベースの作成

### ナレッジベース名

1. ページ左側で **Build** の **ナレッジベース** を選択します。
1. **作成** から **ベクトルストアを含むナレッジベース** を選択します。
1. **ナレッジベース名** に `AnyCompany-kb` と入力します。
1. **IAM 許可** の **ランタイムロール** で **新しいサービスロールを作成して使用** を選択します。
1. **サービスロール名**　はデフォルトのままにしておきます。

### データソースの指定

1. **データソースの詳細** で **Amazon S3** を選択します。
1. **次へ** を選択します。
1. **データソース名** に `AnyCompany-kb-ds` と入力します。
1. **S3 URI** に下記のように入力します。
    - `s3://tnobect-bedrock-work-kb-自分の番号`
    - 例: s3://tnobect-bedrock-work-kb-99
1. その他はすべてデフォルトのままにして **次へ** を選択します。

### 埋め込みモデルの指定

1. **埋め込みモデル** で **モデルを選択** を選択します。
1. **Amazon** の **Titan Embneddings V2** を選択します。
1. **適用** を選択します。

### ベクトルデータベースの指定

1. **ベクトルデータベース**　セクションを表示します。 
1. **ベクトルストアの作成方法** **新しいベクトルストアをクイック作成** を選択します。
1. **ベクトルストア** で **Amazon OpenSearch Serverless** を選択します。
1. **次へ** を選択します。
1. ページを下にスクロールして **ナレッジベースを作成** をクリックします。
1. 作成が完了するまで数分待ちます。

### データソースの同期

1. **AnyCompany-kb** のページで **データソース** のセクションを表示します。
1. **AnyCompany-kb-ds** のチェックボックスをチェックして **同期** を選択します。
1. ページ上部に緑色で同期の完了メッセージが出るまで待ちます。

### データソースのテスト

1. **ナレッジベースをテスト** を選択します。
1. **モデルを選択** を選択します。
1. **Amazon** の **Nova Lite** を選択して **適用** を選択します。
1. ページ下側で下記のプロンプトを入力します。
    - `AnyCompany社では社員が結婚するときに何日間休暇が与えられますか？`
1. Enter キーで送信します。
1. モデルからの回答を確認します。
1. 他にも下記のようなプロンプトを試してみましょう
    - `AnyCompany社の就業規則は労働基準法の第何条に基づいて規定されていますか？`
    - `AnyCompany社では社員が裁判員になった場合に休暇は与えられますか？`
    - `AnyCompany社では取得しなかった有給休暇は繰越すことができますか？`

1. **Amazon Bedrock のナレッジベースで、企業の独自のデータを使用して基盤モデルに問い合わせを行えることを確認しました。**

1. 以降は、作成したリソースの削除処理を行います。
---
## ナレッジベースの削除
1. ページ左側で **オーケストレーション** の **ナレッジベース** を選択します。
1. **ナレッジベース** で **AnyCompany-kb** をラジオボタンを選択して、**削除** を選択します。
1. 確認のダイアログで `delete` と入力して **削除** を選択します。
1. 削除処理が完了しない場合、3 分ほど待った後、ページをリロードしてみてください。

## Amazon OpenSearch Serverless の削除
1. AWS マネジメントコンソールのページ上部の **検索**で `opensearch` と入力して **Amazon OpenSearch Service** のメニューを選択します。
1. ページ左側で **Serverless** の **Collections** を選択します。
1. **コレクション名** が **becrock-knowledge-base-** から始まる行のチェックボックスをチェックします。
1. **削除** を選択します。
1. 削除確認のダイアログで `確認` を入力し、**削除** を選択します。
1. ページ左側で **Serverless** の **Security** の **Data access policies** を選択します。
1. **アクセスポリシー名** が **becrock-knowledge-base-** から始まる行のチェックボックスをチェックします。
1. **削除** を選択します。
1. 削除確認のダイアログで `確認` を入力し、**削除** を選択します。
1. ページ左側で **Serverless** の **Security** の **Encryption policies** を選択します。
1. **暗号化ポリシー名** が **becrock-knowledge-base-** から始まる行のチェックボックスをチェックします。
1. **削除** を選択します。
1. 削除確認のダイアログで `確認` を入力し、**削除** を選択します。
1. ページ左側で **Serverless** の **Security** の **Network policies** を選択します。
1. **ネットワークポリシー名** が **becrock-knowledge-base-** から始まる行のチェックボックスをチェックします。
1. **削除** を選択します。
1. 削除確認のダイアログで `確認` を入力し、**削除** を選択します。

## Amazon S3 のオブジェクトとバケットの削除

1. AWS マネジメントコンソールのページ上部の **検索**で `s3` と入力して **S3** のメニューを選択します。
1. バケットの名前で、**tnobect-bedrock-work-kb-ご自分の番号** の横のラジオボタンを選択します。
1. **空にする** を選択します。
1. オブジェクトをすべて完全に削除する確認として `完全に削除` を入力して、**空にする** を選択します。
1. **終了** を選択します。
1. バケットの名前で、**tnobect-bedrock-work-kb-ご自分の番号** の横のラジオボタンを選択します。
1. **削除** を選択します。
1. バケットを削除する確認としてバケット名を入力して、**バケットを削除** を選択します。
---
### お疲れさまでした。

* **このワークの環境は、ワークを実施する時間帯のみ使用可能です。**

