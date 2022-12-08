#!/bin/bash

SRC_DIR=$GITHUB_WORKSPACE/ibm/mas_devops/roles
TO_DIR=$GITHUB_WORKSPACE/docs/roles

mkdir -p $TO_DIR

function copyDoc() {
  ROLE=$1
  cp $SRC_DIR/$ROLE/README.md $TO_DIR/$ROLE.md
}

copyDoc ansible_version_check
copyDoc appconnect
copyDoc cert_manager
copyDoc cert_manager_upgrade
copyDoc cert_manager_upgrade_check
copyDoc cluster_monitoring
copyDoc common_services
copyDoc cos
copyDoc cos_bucket
copyDoc cp4d
copyDoc cp4d_hack_worker_nodes
copyDoc cp4d_service
copyDoc cp4d_upgrade
copyDoc db2
copyDoc db2_backup
copyDoc db2_restore
copyDoc gencfg_jdbc
copyDoc gencfg_watsonstudio
copyDoc gencfg_workspace
copyDoc ibm_catalogs
copyDoc install_operator
copyDoc kafka
copyDoc mirror_case_prepare
copyDoc mirror_extras_prepare
# copyDoc mirror_ocp_operators
copyDoc mirror_ocp_release
copyDoc mirror_images
copyDoc mongodb
copyDoc nvidia_gpu
copyDoc ocp_contentsourcepolicy
copyDoc ocp_deprovision
copyDoc ocp_disable_updates
copyDoc ocp_github_oauth
copyDoc ocp_login
copyDoc ocp_provision
copyDoc ocp_roks_upgrade_registry_storage
copyDoc ocp_simulate_disconnected_network
copyDoc ocp_upgrade
copyDoc ocp_verify
copyDoc ocs
copyDoc registry
copyDoc sbo
copyDoc sbo_upgrade
copyDoc sls
copyDoc suite_app_config
copyDoc suite_app_install
copyDoc suite_app_upgrade
copyDoc suite_config
copyDoc suite_db2_setup_for_manage
copyDoc suite_dns
copyDoc suite_install
copyDoc suite_install_digest_cm
copyDoc suite_manage_attachments_config
copyDoc suite_manage_bim_config
copyDoc suite_manage_load_dbc_scripts
copyDoc suite_manage_logging_config
copyDoc suite_mustgather
copyDoc suite_mustgather_download
copyDoc suite_upgrade
copyDoc suite_verify
copyDoc uds
copyDoc cis