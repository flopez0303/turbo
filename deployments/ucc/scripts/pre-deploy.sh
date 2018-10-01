#!/usr/bin/env bash
# What you get:
# $DEPLOYMENT_NAME: Contains the deployment name in the form of "<env_name>-<deployment>"
# $DEPLOYMENT_HOME: Is the folder where all your deployment files and folder live
# $DEPLOYMENT_REPO_FOLDER: Folder where your repo is checked-out
#
#
# What you set:
# DEPLOYMENT_REPO: Optional. Checks out this repo in $DEPLOYMENT_REPO_FOLDER
# DEPLOYMENT_REPO_VERSION: Optional. Checks out this specific version/tags/commit of the $DEPLOYMENT_REPO
#
# do_deploy Template
# do_deploy() {
#   local DEPLOYMENT_OPS_FILES="-o $DEPLOYMENT_REPO_FOLDER/my-ops-file.yml"
#
# 	bosh -e $BOSH_ENV deploy -d "$DEPLOYMENT_NAME" "$DEPLOYMENT_REPO_FOLDER/cluster/concourse.yml" \
# 		-l "$DEPLOYMENT_HOME/versions/versions.yml" \
# 		$DEPLOYMENT_OPS_FILES \
# 		$DEPLOYMENT_OPS_FILES_ADD \
#       --var xxx="$MY_TF_ENV_VAR" \
#       -n
#   return $?
# }

do_deploy() {
	bosh -e $BOSH_ENV deploy -d "$DEPLOYMENT_NAME" "$DEPLOYMENT_HOME/manifest/manifest.yml" \
		-l "$DEPLOYMENT_HOME/versions/versions.yml" \
		$DEPLOYMENT_OPS_FILES_ADD \
		--var deployment_name="$DEPLOYMENT_NAME" \
		--var env_name="${TF_ENV_NAME}" \
		--var az_list="$TF_AZ_LIST" \
		--var network_name=concourse \
		--var concourse_external_url="$TF_CONCOURSE_EXTERNAL_URL" \
		--var web_vm_type="concourse-web-$TF_CONCOURSE_WEB_VM_TYPE" \
		--var web_vm_count="$TF_CONCOURSE_WEB_VM_COUNT" \
		--var worker_vm_type="worker-$TF_CONCOURSE_WORKER_VM_TYPE" \
		--var worker_vm_count="$TF_CONCOURSE_WORKER_VM_COUNT" \
		--var db_vm_type="db-$TF_DB_VM_TYPE" \
		--var db_persistent_disk_size="${TF_DB_PERSISTENT_DISK_SIZE}G" \
		--var db_static_ip="$TF_DB_STATIC_IP" \
		--var domain_name="$TF_DOMAIN_NAME" \
		--var credhub_url="$TF_CREDHUB_URL" \
		--var uaa_dns="$TF_UAA_DNS_ENTRY" \
		--var uaa_url="$TF_UAA_URL" \
		--var credhub_dns="$TF_CREDHUB_DNS_ENTRY" \
		--var metrics_static_ip="$TF_METRICS_STATIC_IP" \
		--var concourse_admin_password="$TF_CONCOURSE_ADMIN_PASSWORD" \
		--var credhub_admin_password="$TF_CREDHUB_ADMIN_PASSWORD" \
		--var uaa_admin_password="$TF_UAA_ADMIN_PASSWORD" \
		--var metrics_admin_password="$TF_METRICS_ADMIN_PASSWORD" \
		--var-file lb_ca=<(echo -n "$TF_CA_CERT") \
		--var-file lb_public_key=<(echo -n "$TF_LB_PUB_KEY") \
		$(if [ "x$TF_DEBUG" == "xtrue" ]; then echo "--no-redact"; fi) \
		-n

	#--var-file credhub_ca_cert=<(echo -n "$TF_CA_CERT") \
	return $?
}
