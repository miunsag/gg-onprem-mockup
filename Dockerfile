ARG __from_img=azdevopspj1acr.azurecr.io/msr-1011-lean-original-recipe:Fixes_22-10-03
FROM ${__from_img}

COPY ./code/is-packages/SagServiceMockup ${SAG_HOME}/IntegrationServer/packages/SagServiceMockup
