# CloudRun Ruby Sample

## 手順

```
gcloud config set run/region asia-northeast1

export PROJECT_ID={プロジェクトID}
export TOPIC_NAME=run-with-pubsub
export PROJECT_NUMBER={プロジェクトナンバー}
export INVOKER_ACCOUNT=cloud-run-pubsub-invoker-test
export RUN_NAME=pubsub-tutorial

# 事前に作っておく
export BUCKET={GCSバケット名}

gcloud pubsub topics create $TOPIC_NAME
gcloud builds submit --tag gcr.io/$PROJECT_ID/pubsub
gcloud run deploy $RUN_NAME --image gcr.io/$PROJECT_ID/pubsub --platform managed --region asia-northeast1 --update-env-vars BUCKET=$BUCKET,PROJECT_ID=$PROJECT_ID --timeout 15m

export SERVICE_URL={CloudRunのURL} + '/'

gcloud projects add-iam-policy-binding $PROJECT_ID \
     --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator

gcloud iam service-accounts create $INVOKER_ACCOUNT \
     --display-name "Cloud Run Pub/Sub Invoker"

gcloud run services add-iam-policy-binding $RUN_NAME \
   --member=serviceAccount:$INVOKER_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
   --role=roles/run.invoker --platform managed --region asia-northeast1

gcloud pubsub subscriptions create myRunSubscription2 --topic $TOPIC_NAME \
   --push-endpoint=$SERVICE_URL/ \
   --push-auth-service-account=$INVOKER_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com

gcloud pubsub topics publish $TOPIC_NAME --message "Runner"
```

- secret manager

```
echo 'hoge fuga' | gcloud secrets create my-secret --data-file=-
```

### ローカル開発の場合
サービスアカウントを追加して鍵ファイルをダウンロードする
- 必要権限
    - SecretManagerのアクセス権

docker-compose.ymlのvolumes,environmentで鍵の場所を指定

```yaml
    environment:
      - GOOGLE_APPLICATION_CREDENTIALS=/secrets.json
    volumes:
      - ./secrets.json:/secrets.json
```


ログから中身を確認できる

## ToDo
- [x] Pub/Sub経由でCloudRunを動作させる
- [x] GCSへ適当なファイルをアップロードする
- [ ] GCSから適当なファイルをダウンロードして処理する
- [x] SecretManagerからAPIキー的なものを取得してAPIを使用する
- [ ] BigQueryへデータを入れ込む
- [ ] エラー検知
    - 500とか返せばOKかな
- [ ] ローカルでの実行環境用意
    - [x] コンテナだけローカル
    - [ ] GCSのモック
    - [ ] SecretManagerのモック
