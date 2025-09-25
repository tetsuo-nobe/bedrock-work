import boto3
import json

# Bedrock Agent Runtime クライアントを作成
client = boto3.client('bedrock-agent-runtime', region_name='us-west-2')

# 入力データ（Dict）
input = {"dest":"東京", "count": 3, "objectKey": "blog2.md"}

try:
    # フローを呼び出し
    response = client.invoke_flow(
        flowIdentifier='XXXXXXXXXX',  # フロー ID
        flowAliasIdentifier='XXXXXXXXXX',  # エイリアス ID
        inputs=[
            {
                'content': {
                    'document': input
                },
                'nodeName': 'FlowInputNode',
                'nodeOutputName': 'document'
            }
        ]
    )
except Exception as e:
    print(f"エラー: {e}")
    exit(1)

# レスポンスを処理
if response['ResponseMetadata']['HTTPStatusCode'] == 200:
    print(response)
    # ストリーミングレスポンスを処理
    for event in response['responseStream']:
        if 'flowOutputEvent' in event:
            output = event['flowOutputEvent']
            print(f"ノード名: {output['nodeName']}")
            print(f"出力: {output['content']['document']}")
        elif 'flowCompletionEvent' in event:
            print("フロー完了")
            break

