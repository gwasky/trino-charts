#!/bin/bash

export region=eu-central-1
helm package ./charts/trino -d build/
helm repo index ./
#sed 's+build+head+g' ./index.yaml > ./index.yaml

# Crossplatform sed workaround from: https://unix.stackexchange.com/questions/92895/how-can-i-achieve-portability-with-sed-i-in-place-editing
case $(sed --help 2>&1) in
  *GNU*) set sed -i;;
  *) set sed -i '';;
esac

# "$@" -e 's+build+https://supabase-community.github.io/supabase-kubernetes/build+g' ./index.yaml

"$@" -e 's+build+s3://de-dev-helm-repository/trino/+g' ./index.yaml


#az storage blob upload --overwrite --account-name funclusiongrouphelmrepo --container-name supabase --file index.yaml --name index.yaml
#az storage blob upload --overwrite --account-name funclusiongrouphelmrepo --container-name supabase --file build/supabase-0.0.9.tgz --name supabase-0.0.9.tgz


aws s3api put-object --bucket de-dev-helm-repository --region ${region} --key trino/index.yaml --body index.yaml
aws s3api put-object --bucket de-dev-helm-repository --region ${region} --key trino/trino-0.8.0.tgz --body build/trino-0.8.0.tgz
