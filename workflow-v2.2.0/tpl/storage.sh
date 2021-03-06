#!/bin/bash
store=`grep "storage\s*=\s*" $HELM_GENERATE_DIR/tpl/generate_params.toml | cut -d "=" -f2 | tr -dc '[:alnum:]\n\r'`
if [ "$STORAGE_TYPE" = "minio" ] || ( [ -z "$STORAGE_TYPE" ] && [ "$store" = "minio" ] ); then
  helmc tpl -d $HELM_GENERATE_DIR/tpl/generate_params.toml -o $HELM_GENERATE_DIR/manifests/deis-minio-rc.yaml $HELM_GENERATE_DIR/tpl/deis-minio-rc.yaml
  cp $HELM_GENERATE_DIR/tpl/deis-minio-service* $HELM_GENERATE_DIR/manifests/
else
  rm -rf $HELM_GENERATE_DIR/manifests/deis-minio-*
fi

database_location=`grep "database_location\s*=\s*" $HELM_GENERATE_DIR/tpl/generate_params.toml | cut -d "=" -f2 | tr -dc '[:alnum:]-\n\r'`
if [ "$DATABASE_LOCATION" = "on-cluster" ] || ( [ -z "$DATABASE_LOCATION" ] && [ "$database_location" = "on-cluster" ] ); then
  helmc tpl -d $HELM_GENERATE_DIR/tpl/generate_params.toml -o $HELM_GENERATE_DIR/manifests/deis-database-rc.yaml $HELM_GENERATE_DIR/tpl/deis-database-rc.yaml
  cp $HELM_GENERATE_DIR/tpl/deis-database-service* $HELM_GENERATE_DIR/manifests/
else
  rm -rf $HELM_GENERATE_DIR/manifests/deis-database-*
fi
helmc tpl -d $HELM_GENERATE_DIR/tpl/generate_params.toml -o $HELM_GENERATE_DIR/manifests/deis-database-secret-creds.yaml $HELM_GENERATE_DIR/tpl/deis-database-secret-creds.yaml

logger_redis_location=`grep "logger_redis_location\s*=\s*" $HELM_GENERATE_DIR/tpl/generate_params.toml | cut -d "=" -f2 | tr -dc '[:alnum:]-\n\r'`
if [ "$LOGGER_REDIS_LOCATION" = "on-cluster" ] || ( [ -z "$LOGGER_REDIS_LOCATION" ] && [ "$logger_redis_location" = "on-cluster" ] ); then
  helmc tpl -d $HELM_GENERATE_DIR/tpl/generate_params.toml -o $HELM_GENERATE_DIR/manifests/deis-logger-redis-rc.yaml $HELM_GENERATE_DIR/tpl/deis-logger-redis-rc.yaml
  cp $HELM_GENERATE_DIR/tpl/deis-logger-redis-service* $HELM_GENERATE_DIR/manifests/
else
  rm -rf $HELM_GENERATE_DIR/manifests/deis-logger-redis-*
fi
helmc tpl -d $HELM_GENERATE_DIR/tpl/generate_params.toml -o $HELM_GENERATE_DIR/manifests/deis-logger-redis-secret-creds.yaml $HELM_GENERATE_DIR/tpl/deis-logger-redis-secret-creds.yaml
