# CloudRun Ruby Sample

## 手順

```
export PROJECT_ID={プロジェクトID}
export TOPIC_NAME=run-with-pubsub
export PROJECT_NUMBER={プロジェクトナンバー}
export INVOKER_ACCOUNT=cloud-run-pubsub-invoker-test
export RUN_NAME=pubsub-tutorial
export SERVICE_URL={CloudRunのURL} + '/'
export BUCKET={GCSバケット名}

gcloud pubsub topics create $TOPIC_NAME
gcloud builds submit --tag gcr.io/$PROJECT_ID/pubsub
gcloud run deploy $RUN_NAME --image gcr.io/$PROJECT_ID/pubsub --platform managed --region asia-northeast1 --update-env-vars BUCKET=$BUCKET

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

ログから中身を確認できる

