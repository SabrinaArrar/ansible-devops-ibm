#!/bin/bash

SRC_DIR=$GITHUB_WORKSPACE/ibm/mas_devops/roles
TO_DIR=$GITHUB_WORKSPACE/docs/roles

mkdir -p $TO_DIR

function copyDoc() {
  ROLE=$1
  cp $SRC_DIR/$ROLE/README.md $TO_DIR/$ROLE.md
}

copyDoc ansible_version_check
copyDoc aws_bucket_access_point
copyDoc aws_documentdb_user
copyDoc aws_policy
copyDoc aws_route53
copyDoc aws_user_creation
copyDoc aws_vpc
copyDoc appconnect
copyDoc cert_manager
copyDoc cis
copyDoc common_services
copyDoc configure_manage_eventstreams
copyDoc cos
copyDoc cos_bucket
copyDoc cp4d
copyDoc cp4d_admin_pwd_update
copyDoc cp4d_service
copyDoc cp4d_upgrade
copyDoc db2
copyDoc db2_backup
copyDoc db2_restore
copyDoc dro
copyDoc eck
copyDoc entitlement_key_rotation
copyDoc gencfg_jdbc
copyDoc gencfg_mongo
copyDoc gencfg_watsonstudio
copyDoc gencfg_workspace
copyDoc grafana
copyDoc ibm_catalogs
copyDoc install_operator
copyDoc kafka
copyDoc mirror_case_prepare
copyDoc mirror_extras_prepare
copyDoc mirror_ocp
copyDoc mirror_images
copyDoc mongodb
copyDoc nvidia_gpu
copyDoc ocp_cluster_monitoring
copyDoc ocp_config
copyDoc ocp_contentsourcepolicy
copyDoc ocp_deprovision
copyDoc ocp_disable_updates
copyDoc ocp_efs
copyDoc ocp_github_oauth
copyDoc ocp_login
copyDoc ocp_node_config
copyDoc ocp_provision
copyDoc ocp_roks_upgrade_registry_storage
copyDoc ocp_simulate_disconnected_network
copyDoc ocp_upgrade
copyDoc ocp_verify
copyDoc ocs
copyDoc registry
copyDoc sls
copyDoc suite_app_config
copyDoc suite_app_install
copyDoc suite_app_uninstall
copyDoc suite_app_upgrade
copyDoc suite_app_rollback
copyDoc suite_config
copyDoc suite_db2_setup_for_manage
copyDoc suite_dns
copyDoc suite_certs
copyDoc suite_install
copyDoc suite_manage_bim_config
copyDoc suite_manage_birt_report_config
copyDoc suite_manage_customer_files_config
copyDoc suite_manage_doclinks_config
copyDoc suite_manage_import_certs_config
copyDoc suite_manage_load_dbc_scripts
copyDoc suite_manage_logging_config
copyDoc suite_manage_pvc_config
copyDoc suite_switch_to_olm
copyDoc suite_upgrade
copyDoc suite_rollback
copyDoc suite_uninstall
copyDoc suite_verify
copyDoc turbonomic
copyDoc uds
