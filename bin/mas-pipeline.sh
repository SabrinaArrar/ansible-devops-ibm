#!/bin/bash
set -e

# !!!! INCOMPLETE / WORK IN PROGRESS / USE AT OWN RISK !!!!

# Load common functions
# -----------------------------------------------------------------------------
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/mas-common.sh


# Install yq v4.23.1
# -----------------------------------------------------------------------------
if [[ ! -e $DIR/yq ]]; then
  echo "Installing YQ v4.23.1 into $DIR"
  wget -q https://github.com/mikefarah/yq/releases/download/v4.23.1/yq_linux_amd64.tar.gz -P $DIR
  tar -xf $DIR/yq_linux_amd64.tar.gz -C $DIR
  rm $DIR/yq_linux_amd64.tar.gz $DIR/yq.1 $DIR/install-man-page.sh
  mv $DIR/yq_linux_amd64 $DIR/yq
fi


# Install the pipeline
# -----------------------------------------------------------------------------
function install_pipeline() {
  # Install pipelines support
  bash pipelines/bin/install-pipelines.sh

  # Build Pipeline definitions
  if [[ -z "$PIPELINE_VERSION" ]]; then
    read -p 'PIPELINE_VERSION> ' PIPELINE_VERSION
  else
    read -e -p 'PIPELINE_VERSION> ' -i "$PIPELINE_VERSION" PIPELINE_VERSION
  fi
  export VERSION=$PIPELINE_VERSION
  export DEV_MODE=true
  bash pipelines/bin/build-pipelines.sh

  # Install the MAS ClusterTask definitions
  oc apply -f pipelines/ibm-mas_devops-clustertasks-$PIPELINE_VERSION.yaml

  # Install the MAS pipeline definition
  oc project mas-sample-pipelines &> /dev/null || oc new-project mas-sample-pipelines
  oc apply -f pipelines/samples/sample-pipeline.yaml
}



# Prepare the pipeline
# -----------------------------------------------------------------------------
function config_pipeline() {
  export MAS_INSTANCE_ID=$1
  set_target

  if confirm "Install IoT Application [y/N]"; then
    export MAS_APP_SOURCE_IOT='""'; export MAS_APP_CHANNEL_IOT=8.4.x
  else
    export MAS_APP_SOURCE_IOT='""'; export MAS_APP_CHANNEL_IOT='""'
  fi

  # Applications that require IoT
  if [[ "$MAS_APP_CHANNEL_IOT" != '""' ]]; then
    if confirm "Install Monitor Application [y/N]"; then
      export MAS_APP_SOURCE_MONITOR='""'; export MAS_APP_CHANNEL_MONITOR=8.7.x
    else
      export MAS_APP_SOURCE_MONITOR='""'; export MAS_APP_CHANNEL_MONITOR='""'
    fi
    if confirm "Install Safety Application [y/N]"; then
      export MAS_APP_SOURCE_SAFETY='""'; export MAS_APP_CHANNEL_SAFETY=8.2.x
    else
      export MAS_APP_SOURCE_SAFETY='""'; export MAS_APP_CHANNEL_SAFETY='""'
    fi
  else
    export MAS_APP_SOURCE_MONITOR='""'; export MAS_APP_CHANNEL_MONITOR='""'
    export MAS_APP_SOURCE_SAFETY='""'; export MAS_APP_CHANNEL_SAFETY='""'
  fi

  if confirm "Install Manage Application [y/N]"; then
    export MAS_APP_SOURCE_MANAGE='""'; export MAS_APP_CHANNEL_MANAGE=8.3.x
  else
    export MAS_APP_SOURCE_MANAGE='""'; export MAS_APP_CHANNEL_MANAGE='""'
  fi

  # Applications that require Manage
  if [[ "$MAS_APP_CHANNEL_MANAGE" != '""' ]]; then
    if confirm "Install Predict Application [y/N]"; then
      export MAS_APP_SOURCE_PREDICT='""'; export MAS_APP_CHANNEL_PREDICT=8.5.x
    else
      export MAS_APP_SOURCE_PREDICT='""'; export MAS_APP_CHANNEL_PREDICT='""'
    fi
    if confirm "Install MSO Application [y/N]"; then
      export MAS_APP_SOURCE_MSO='""'; export MAS_APP_CHANNEL_MSO=8.1.x
    else
      export MAS_APP_SOURCE_MSO='""'; export MAS_APP_CHANNEL_MSO='""'
    fi
  else
    export MAS_APP_SOURCE_PREDICT='""'; export MAS_APP_CHANNEL_PREDICT='""'
    export MAS_APP_SOURCE_MSO='""'; export MAS_APP_CHANNEL_MSO='""'
  fi

  eval "echo \"$(cat pipelines/samples/sample-pipelinesettings-roks.yaml)\"" > pipelinesettings-$MAS_INSTANCE_ID.yaml
  eval "echo \"$(cat pipelines/samples/sample-pipelinerun.yaml)\"" > pipelinerun-$MAS_INSTANCE_ID.yaml
}


# Display the configuration of the pipeline
# -----------------------------------------------------------------------------
function show_config() {
  MAS_INSTANCE_ID=$1
  if [[ ! -e pipelinesettings-$MAS_INSTANCE_ID.yaml ]]; then
    echo "No configuration exists for $MAS_INSTANCE_ID"
    exit 1
  fi

  echo -e "\nIBMCloud Settings"
  echo "-------------------------------------------------------------"
  echo "IBMCLOUD_APIKEY ........... $($DIR/yq '.stringData.IBMCLOUD_APIKEY' pipelinesettings-$MAS_INSTANCE_ID.yaml)"

  echo -e "\nIBM Maximo Application Suite Settings"
  echo "-------------------------------------------------------------"
  echo "MAS_INSTANCE_ID ........... $($DIR/yq '.stringData.MAS_INSTANCE_ID' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "MAS_CATALOG_SOURCE ........ $($DIR/yq '.stringData.MAS_CATALOG_SOURCE' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "MAS_CHANNEL ............... $($DIR/yq '.stringData.MAS_CHANNEL' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "MAS_ICR_CP ................ $($DIR/yq '.stringData.MAS_ICR_CP' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "MAS_ICR_CPOPEN ............ $($DIR/yq '.stringData.MAS_ICR_CPOPEN' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "MAS_ENTITLEMENT_USERNAME .. $($DIR/yq '.stringData.MAS_ENTITLEMENT_USERNAME' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "MAS_ENTITLEMENT_KEY ....... $($DIR/yq '.stringData.MAS_ENTITLEMENT_KEY' pipelinesettings-$MAS_INSTANCE_ID.yaml)"

  echo -e "\nIBM Suite License Service Settings"
  echo "-------------------------------------------------------------"
  echo "SLS_LICENSE_ID ............ $($DIR/yq '.stringData.SLS_LICENSE_ID' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "SLS_ICR_CP ................ $($DIR/yq '.stringData.SLS_ICR_CP' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "SLS_ICR_CPOPEN ............ $($DIR/yq '.stringData.SLS_ICR_CPOPEN' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "SLS_ENTITLEMENT_USERNAME .. $($DIR/yq '.stringData.SLS_ENTITLEMENT_USERNAME' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "SLS_ENTITLEMENT_KEY ....... $($DIR/yq '.stringData.SLS_ENTITLEMENT_KEY' pipelinesettings-$MAS_INSTANCE_ID.yaml)"

  echo -e "\nIBM User Data Services Settings"
  echo "-------------------------------------------------------------"
  echo "UDS_CONTACT_EMAIL ......... $($DIR/yq '.stringData.UDS_CONTACT_EMAIL' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "UDS_CONTACT_FIRSTNAME ..... $($DIR/yq '.stringData.UDS_CONTACT_FIRSTNAME' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
  echo "UDS_CONTACT_LASTNAME ...... $($DIR/yq '.stringData.UDS_CONTACT_LASTNAME' pipelinesettings-$MAS_INSTANCE_ID.yaml)"
}


# Launch the pipeline run
# -----------------------------------------------------------------------------
function run_pipeline() {
  OCP_CONSOLE_ROUTE=$(oc -n openshift-console get route console -o=jsonpath='{.spec.host}')
  echo "Connected to OCP cluster: https://$OCP_CONSOLE_ROUTE"
  confirm "Proceed with deployment on this cluster [y/N] " || exit 0

  MAS_INSTANCE_ID=$1
  MAS_CONFIG_DIR=$2
  if [[ ! -e "pipelinesettings-$MAS_INSTANCE_ID.yaml" ]]; then
    echo "No configuration exists for $MAS_INSTANCE_ID"
  fi

  echo ""
  echo "Deploying via in-cluster Tekton Pipeline"
  show_config $MAS_INSTANCE_ID
  confirm "Proceed with these settings [y/N] " || exit 0

  fail=0
  if [[ ! -e "$MAS_CONFIG_DIR/workspace_masdev.yaml" ]]; then
    echo "Error: Missing required file: $MAS_CONFIG_DIR/workspace_masdev.yaml"
    fail=1
  fi
  if [[ ! -e "$MAS_CONFIG_DIR/entitlement.lic" ]]; then
    echo "Error: Missing required file: $MAS_CONFIG_DIR/entitlement.lic"
    fail=1
  fi
  if [[ ! -e "pipelinesettings-$MAS_INSTANCE_ID.yaml" ]]; then
    echo "Error: Missing required file: pipelinesettings-$MAS_INSTANCE_ID.yaml.  Run $0 config"
    fail=1
  fi
  if [[ ! -e "pipelinerun-$MAS_INSTANCE_ID.yaml" ]]; then
    echo "Error: Missing required file: pipelinerun-$MAS_INSTANCE_ID.yaml.  Run $0 config"
    fail=1
  fi
  if [[ $fail == 1 ]]; then
    exit 1
  fi

  # Update pipeline settings
  oc apply -f pipelinesettings-$MAS_INSTANCE_ID.yaml

  # Clean up existing secrets
  oc delete secret pipeline-additional-configs --ignore-not-found=true
  oc delete secret pipeline-sls-entitlement --ignore-not-found=true

  # Create new secrets
  oc create secret generic pipeline-additional-configs --from-file=$MAS_CONFIG_DIR/workspace_masdev.yaml
  oc create secret generic pipeline-sls-entitlement --from-file=$MAS_CONFIG_DIR/entitlement.lic

  # Start pipeline execution
  oc create -f pipelinerun-$MAS_INSTANCE_ID.yaml
}


case $1 in

  install)
    install_pipeline
    ;;

  config|set-config)
    config_pipeline $2
    ;;

  show|show-config)
    show_config $2
    ;;

  run|run)
    run_pipeline $2 $3
    ;;

  *)
    echo "unknown parameter"
    exit 1
    ;;
esac
