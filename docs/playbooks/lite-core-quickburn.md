# MAS Core Service on DevIT Quickburn

This master playbook will drive the following playbooks in sequence:

- [Provision & setup Quickburn](ocp.md#quickburn) (25 minutes)
- Install dependencies:
    - [Install MongoDb](dependencies.md#install-mongodb-ce) (10 minutes)
    - [Install SLS](dependencies.md#install-sls) (10 minutes)
- Install & configure MAS:
    - [Configure Cloud Internet Services integration](mas.md#cloud-internet-services-integration) (Optional, 1 minute)
    - Generate MAS Workspace Configuration (1 minute)
    - [Install & configure MAS](mas.md#install-mas) (15 minutes)

All timings are estimates, see the individual pages for each of these playbooks for more information.  Due to the size limtations of QuickBurn clusters a full MAS stack is not possible.

## Required environment variables
- `FYRE_USERNAME`
- `FYRE_APIKEY`
- `FYRE_PRODUCT_ID`
- `CLUSTER_NAME` The name to assign to the new ROKS cluster
- `MAS_INSTANCE_ID` Declare the instance ID for the MAS install
- `MAS_ENTITLEMENT_KEY` Lookup your entitlement key from the [IBM Container Library](https://myibm.ibm.com/products-services/containerlibrary)
- `MAS_CONFIG_DIR` Directory where generated config files will be saved (you may also provide pre-generated config files here)
- `SLS_LICENSE_ID` The license ID must match the license file available in `$MAS_CONFIG_DIR/entitlement.lic`
- `SLS_ENTITLEMENT_KEY` Lookup your entitlement key from the [IBM Container Library](https://myibm.ibm.com/products-services/containerlibrary)

## Optional environment variables
Refer to the role documentation for full details of all configuration options available in this playbook:

1. [ocp_provision](../roles/ocp_provision.md)
2. [ocp_setup_mas_deps](../roles/ocp_setup_mas_deps.md)
3. [mongodb](../roles/mongodb.md)
4. [sls_install](../roles/sls_install.md)
5. [gencfg_sls](../roles/gencfg_sls.md)
6. [gencfg_workspace](../roles/gencfg_workspace.md)
7. [suite_dns](../roles/suite_dns.md)
8. [suite_install](../roles/suite_install.md)
9. [suite_config](../roles/suite_config.md)
10. [suite_verify](../roles/suite_verify.md)


## Release build

```bash
# Fyre credentials
export FYRE_USERNAME=xxx
export FYRE_APIKEY=xxx
export FYRE_PRODUCT_ID=225
# Cluster configuration
export CLUSTER_NAME=xxx
export OCP_VERSION=4.6.16

# MAS configuration
export MAS_INSTANCE_ID=xxx
export MAS_ENTITLEMENT_KEY=xxx

export MAS_CONFIG_DIR=~/masconfig

ansible-playbook playbooks/lite-core-quickburn.yml
```

!!! note
    Lookup your entitlement keys from the [IBM Container Library](https://myibm.ibm.com/products-services/containerlibrary)


## Pre-release build

```bash
# Fyre credentials
export FYRE_USERNAME=xxx
export FYRE_APIKEY=xxx
export FYRE_PRODUCT_ID=225

# Cluster configuration
export CLUSTER_NAME=xxx
export OCP_VERSION=4.6.16

# Allow development catalogs to be installed
export W3_USERNAME=xxx
export ARTIFACTORY_APIKEY=xxx

# MAS configuration
export MAS_CATALOG_SOURCE=ibm-mas-operators
export MAS_CHANNEL=8.5.0-pre.m2dev85
export MAS_INSTANCE_ID=xxx

export MAS_ICR_CP=wiotp-docker-local.artifactory.swg-devops.com
export MAS_ICR_CPOPEN=wiotp-docker-local.artifactory.swg-devops.com
export MAS_ENTITLEMENT_USERNAME=$W3_USERNAME_LOWERCASE
export MAS_ENTITLEMENT_KEY=$ARTIFACTORY_APIKEY

export MAS_CONFIG_DIR=~/masconfig

ansible-playbook playbooks/lite-core-quickburn.yml
```
