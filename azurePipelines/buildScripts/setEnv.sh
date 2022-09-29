#!/bin/bash

# Pipeline parameters
export AZ_BASE_IMAGE_REPO="msr-1011-lean-original-recipe"
export AZ_BASE_IMAGE_FIXES_TAG="Fixes_22-09-26"
export AZ_BASE_IMAGE_TAG="${AZ_PIPE_CR_URL}/${AZ_BASE_IMAGE_REPO}:${AZ_BASE_IMAGE_FIXES_TAG}"

export AZ_ACR_REPO_NAME="sag-api-mockup"
export OUR_SERVICE_TAG_BASE="${AZ_PIPE_CR_URL}/${AZ_ACR_REPO_NAME}"