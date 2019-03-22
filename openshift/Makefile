PROJECT=viaa-tools
WD=/tmp
REPO_URI=https://github.com/viaacode/Mint2.git
GIT_NAME=Mint2
APP_NAME=mint2
TAG=${ENV}
TOKEN=`oc whoami -t`
path_to_oc=`which oc`
oc_registry=docker-registry-default.apps.do-prd-okp-m0.do.viaa.be
.ONESHELL:
SHELL = /bin/bash
.PHONY:	all
check-env:
ifndef ENV
  $(error ENV is undefined)
endif
OC_PROJECT=${PROJECT}
ifndef BRANCH
  $(error BRANCH is undefined)
endif

commit:
	git add .
	git commit -a
	git push
checkTools:
	if [ -x "${path_to_executable}" ]; then  echo "OC tools found here: ${path_to_executable}"; else echo please install the oc tools: https://github.com/openshiftorigin/releases/tag/v3.9.0; fi; uname && netstat | grep docker| grep -e CONNECTED  1> /dev/null || echo docker not running or not using linux
login:	check-env
	oc login do-prd-okp-m0.do.viaa.be:8443
	oc new-project "${OC_PROJECT}" || oc project "${OC_PROJECT}"
	sleep 4 && oc new-project "${OC_PROJECT}" || oc project "${OC_PROJECT}"
	oc adm policy add-scc-to-user privileged -n${OC_PROJECT} -z default
	docker login -p "${TOKEN}" -u unused ${oc_registry}

clone:
	cd /tmp && git clone  --single-branch -b ${BRANCH} "${REPO_URI}" 

buildimage:
	cd /tmp/${GIT_NAME}
	docker build -t ${oc_registry}/${OC_PROJECT}/${APP_NAME}:${TAG} .
push:
	docker push ${oc_registry}/${OC_PROJECT}/${APP_NAME}:${TAG}
deploy:
	cd  /tmp/${GIT_NAME}/openshift && oc apply -f mint2.yaml
delete:
	oc delete project ${OC_PROJECT}
clean:
	rm -rf /tmp/${GIT_NAME}
podshell:
	oc exec -ti `oc get pods | grep es-ingest | cut -d ' ' -f 1 |grep -v deploy|head -n1`  bash
allfirsttime:	clean login clone buildimage deploy   clean
all:   clean login clone buildimage push clean


