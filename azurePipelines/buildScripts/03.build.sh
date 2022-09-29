#!/bin/bash

echo "Getting service principal credentials..."
if [ ! -f "${CRCREDENTIALS_SECUREFILEPATH}" ]; then
  echo "Secure file path not present: ${CRCREDENTIALS_SECUREFILEPATH}"
  exit 1
fi

chmod u+x "${CRCREDENTIALS_SECUREFILEPATH}"
. "${CRCREDENTIALS_SECUREFILEPATH}"

if [ -z ${AZ_PIPE_CR_USER+x} ]; then
  echo "Secure information has not been sourced correctly, AZ_PIPE_CR_USER is missing"
  exit 2
fi

if [ -z ${AZ_PIPE_CR_PASS+x} ]; then
  echo "Secure information has not been sourced correctly, AZ_PIPE_CR_PASS is missing"
  exit 3
fi

. ./azurePipelines/buildScripts/setEnv.sh

echo "Logging in to repository ${AZ_PIPE_CR_URL}"
buildah login -u "${AZ_PIPE_CR_USER}" -p "${AZ_PIPE_CR_PASS}" "${AZ_PIPE_CR_URL}"  || exit 4

echo "Building tag ${OUR_SERVICE_TAG_BASE}"
buildah bud \
  --build-arg __base_image=${AZ_BASE_IMAGE_TAG} \
  --format docker \
  -t "${OUR_SERVICE_TAG_BASE}"
  
RESULT_build=$?

if [ ${RESULT_build} -ne 0 ]; then
  echo "Build failed with code: ${RESULT_build}"
  buildah logout "${AZ_PIPE_CR_URL}"
  exit 4
fi

crtTag="${OUR_SERVICE_TAG_BASE}:Base-${AZ_BASE_IMAGE_FIXES_TAG}-br-${BUILD_SOURCEBRANCHNAME}-${JOB_DATETIME}"

echo "Tagging ${OUR_SERVICE_TAG_BASE} to ${crtTag}"
buildah tag "${OUR_SERVICE_TAG_BASE}" "${crtTag}"

echo "Pushing tag ${crtTag}"
buildah push "${crtTag}"

if [[ "${BUILD_SOURCEBRANCHNAME}" == "main" ]]; then
  echo "Pushing tag ${OUR_SERVICE_TAG_BASE}"
  buildah push "${OUR_SERVICE_TAG_BASE}"
fi

echo "Logging out"
buildah logout "${AZ_PIPE_CR_URL}"

echo "Push completed"
