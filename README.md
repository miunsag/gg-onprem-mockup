# Software AG Mainstream DevOps Style API Mockup Service

- [Software AG Mainstream DevOps Style API Mockup Service](#software-ag-mainstream-devops-style-api-mockup-service)
  - [Prerequisites](#prerequisites)
  - [Quickstart](#quickstart)
  - [Mocking services](#mocking-services)
    - [Classical flow services](#classical-flow-services)
      - [SoftwareAG.Mockup.flow:genericGet](#softwareagmockupflowgenericget)
        - [Input Parameters:](#input-parameters)
        - [Ways to call](#ways-to-call)

This project offers an IS package that can be used as an API mockup service provider during system tests.

## Prerequisites

- a container registry containing an MSR (not IS) image built with the usual Software AG conventions, in particular having the SAG_HOME variable defined
  - an IS image is still usable, however you might need to adapt the Dockerfile paths accordingly
- optional: an Azure DevOps account where you can import the pipeline
- optional: a docker-compose enabled development machine

## Quickstart

- open a browser to [this repository](https://github.com/SoftwareAG/sag-mainstream-devops-az-03-03-api-mockup)
- use the repository as a template and create your own
- optional: setup an Azure Devops project to build your own images
  - the project must have a VMSS type agent pool as decribed in the [DevOps prerequisite respository](https://github.com/SoftwareAG/sag-mainstream-devops-az-00-prerequisites)
  - the project will need a secure file named `cr.credentials.secret.sh` containing the container registry URL and credentials. use the [provided example](./azurePipelines/support/example.cr.credentials.secret.sh)
  - edit `azurePipelines/buildscripts/setenv.sh` to match your preference or context
- optional: if you want to expand the service or add your owns, use the [development run configuration](./run-configurations/api-mockup-dev-01/).
  - copy `example.env` into `.env`
  - edit `.env` to match your environment
  - start the docker compose project
  - connect a designer to the instance
  - make your changes
  - committing to git will trigger the build pipeline if configured
- the resulting container image will generate containers having mocking services as described below

## Mocking services

### Classical flow services

#### SoftwareAG.Mockup.flow:genericGet

##### Input Parameters:

|Parameter|Type|Default value|Description
|-|-|-|-
|sleepIntervalMilliseconds|string constrained to positive integer|1|Time the service will sleep
|unmanagedExceptionProbability|string contrained to double, must be >=0 <=1|0.01|Probability for the service to throw a simulated exception towards the caller
|managedExceptionProbability|string contrained to double, must be >=0 <=1|0.01|Probability for the service to throw a simulated exception that is caught in the servie itself
|outputBodySize|string constrained to positive integer|512|

##### Ways to call

- via http get, classical style
  - `http://host:port/invoke/SoftwareAG.Mockup.flow/genericGet?`
  - `http://host:port/invoke/SoftwareAG.Mockup.flow/genericGet?sleepIntervalMilliseconds=2000`
  - any combination of the above parameters is accepted
- via rest get
  - `http://host:port/rad/SoftwareAG.Mockup.restResource:genericResource/genericResource?`
  - parameters can be added as above, in the query string