ARG __from_img=azdevopspj1acr.azurecr.io/msr-1011-lean-original-recipe:Fixes_22-09-06
# ARG __from_img used below on the final stage
FROM ${__from_img}

COPY ./code/is-packages/SagServiceMockup ${SAG_HOME}/IntegrationServer/packages/SagServiceMockup
