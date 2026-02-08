# プレイグラウンドを触ってみましょう

* **今回の環境はトレーニング内で使用する時間帯だけで利用できます。**
* **指定された操作のみ、実施して下さいますようお願いいたします。**

## 環境へのアクセス

* 講師が URL とユーザー ID やパスワードをご案内します。


## Amazon Bedrock のプレイグラウンドを使用する準備を行いましょう

1. AWS マネジメントコンソールの **コンソールのホーム**　を表示します。
1. ページ右上に、[**米国（オレゴン）**] と表示されていることを確認します。
    - もしオレゴンになっていない場合は、その表示部分をクリックしてオレゴンに切り替えてください。
1. ページ上部の [**検索**] の入力エリアに、`bedrock` と入力して Enter キーを押します。
1. ページ左側のメニュー（ナビゲーションメニュー）で、[**テスト**] の下の [**Playground**] をクリックします。
1. [**モデルを選択**] をクリックします。
1. [**1. カテゴリ**] で [**Amazon**] をクリックします。
1. [**2. モデル**] で [**Nova Lite 1.0**] をクリックします。
    - **注意： 「Nove 2 Lite v1」ではなく、「Nova Lite 1.0」を選択して下さい**
1. [**3. 推論**] で [**推論プロファイル**] - [**US Nova Lite**] が選択されていることを確認します。
1. [**適用**] をクリックします。
1. 「**モード**」が 「**チャット**」になっていることを確認します。
1. 「**モード**」の下の 「**Nova Lite**」の左のアイコンをクリックして [**設定**] を表示します。
1. [**長さ**] で [**Maximum Output Tokens**] に `2048`を入力します。
1. [**設定**] の　右側に表示されている [**<**] をクリックして [**設定**] の表示を閉じます。

## テキストを生成してみましょう
      
1. ページ下部の入力エリアに下記を入力します。

    - ```
      生成 AI についてブログ記事を書いてください。
      ```

1. [**実行**] をクリックします。

1. 生成 AI に関するブログ記事が出力されることを確認します。


## 要約してみましょう


1. ページ下部の入力エリアに下記を入力します。

    - ```
      以下の文章を100文字程度に要約して下さい。

      AWSは顧客からのすべてのフィードバックを受け、今日、私たちは AI 21ラボ、アンソロピック、スタビリティAI、そしてアマゾンのFMにAPIを介してアクセスできる新しいサービス「Amazon Bedrock」の発表を喜んで行います。
      Bedrockは、顧客がFMを使用して生成AIベースのアプリケーションを構築およびスケーリングする最も簡単な方法であり、すべてのビルダーにアクセスを民主化します。
      Bedrockは、スケーラブル、信頼性、セキュリティが高いAWS管理サービスを通じて、テキストと画像の強力なFM(アマゾンの新しい2つのLLMを含むTitan FMを含む)にアクセスする機能を提供します。
      Bedrockのサーバーレス体験により、顧客は自分が行おうとしていることに適したモデルを簡単に見つけ、すぐに開始し、独自のデータでFMをプライベートにカスタマイズし、インフラストラクチャを管理する必要なく(Amazon SageMakerのMLの機能であるExperimentsを使って異なるモデルをテストしたり、Pipelinesを使ってFMを大規模に管理したりするインテグレーションを含む)、慣れ親しんだAWSのツールと機能を使ってそれらを簡単にアプリケーションに統合およびデプロイできます。
      ```

1. [**実行**] をクリックします。

1. 要約された文章が出力されることを確認します。


## 翻訳してみましょう
   
1. ページ下部の入力エリアに下記を入力します。

    - ```
      以下の英文を日本語に翻訳して下さい。

      AWS took all of that feedback from customers, and today we are excited to announce Amazon Bedrock, 
      a new service that makes FMs from AI21 Labs, Anthropic, Stability AI, and Amazon accessible via an API. 
      Bedrock is the easiest way for customers to build and scale generative AI-based applications using FMs, 
      democratizing access for all builders. Bedrock will offer the ability to access a range of powerful FMs 
      for text and images—including Amazons Titan FMs, which consist of two new LLMs we’re also announcing 
      today—through a scalable, reliable, and secure AWS managed service. With Bedrock’s serverless experience, 
      customers can easily find the right model for what they’re trying to get done, get started quickly, privately 
      customize FMs with their own data, and easily integrate and deploy them into their applications using the AWS 
      tools and capabilities they are familiar with, without having to manage any infrastructure (including integrations 
      with Amazon SageMaker ML features like Experiments to test different models and Pipelines to manage their FMs at scale).
      ```
   　 
   
1. 翻訳された結果が日本語で表示されることを確認します。

## チャットで質問してみましょう

1. ページ下部の入力エリアに下記の例の質問を入力して実行してみましょう。

    - 正しい回答が得られているかも確認してみましょう。
    - 同じ質問を何度か繰り返してきいてみましょう。

* 例1:
     ```
     ショッピングサイトで有名なAmazon社を創設したのは誰でしょう？
     ```

* 例2:
     ```
     次の要件を満たす JavaScriptを含むHTMLを生成して下さい。ページの背景色は青です。ボタンをクリックすると、大きな見出しでフォントの色が白のHelloと表示されます。
     ```

* 例3:
    ```
   （ご自身の会社や組織）では社員が結婚するときに何日間休暇をもらえますか？
    ```

* 例4:
    ```
    明日は何日ですか？
    ```

* 例5:
    ```
    3.14 を 0.12345 乗するとどんな値になりますか？
    ```
    - 正解は、1.1517174978619817 

## マルチモーダルの処理を試してみましょう

1. [こちら](https://dl39k3l39to9h.cloudfront.net/cat.png) を右クリックして、リンク先を保存し、猫の画像: **cat.png** をダウンロードして下さい。
1. ページ下部の入力エリアに下記を入力します。
    ```
    添付の画像の内容について説明して下さい。
    ```
1. プレイグラウンドで、入力エリアの下側にある **クリップのアイコン（Attach File アイコン)** をクリックします。
1. [**コンピューターからアップロード**] からアップロードをクリックします。
1. ダウンロードした **cat.png** を選択します。
1. [**実行**] をクリックします。
1. 画像の内容を説明しているテキストが生成されたことを確認します。

## 画像を生成してみましょう

1. 「**モード**」の下の 「**Nova Lite**」の左のアイコンをクリックして [**設定**] を表示します。
1. 「**Nova Lite 1.0**」と表示されているエリアの鉛筆アイコンをクリックします。
1. 「**Input**」で、「**Text**」を選択します。
1. 「**Output**」で、「**Image**」を選択します。 
1. [**1. カテゴリ**] で [**Amazon**] をクリックします。
1. [**2. モデル**] で [**Titan Image Generator G1 v2**] をクリックします。
1. [**3. 推論**] で [**オンデマンド**] が選択されていることを確認します。
1. [**適用**] をクリックします。
1. 「**モード**」の下の 「**Nova Lite**」の左のアイコンをクリックします。
1. ページ左側の [**応答画像**] で [**画像数**] を **1** に変更します。

1. ページ下部の入力エリアに下記を入力して実行してみましょう。

    - ```
      Image of a cat relaxing in the park
      ```

1. 画像が 1 枚出力されることを確認します。

### お疲れさまでした！生成 AI でどのようなことができるかを確認できました。















































