#!/bin/bash

echo "Checking if IS is up..."

while ! nc -z msr-test-01 5555 ; do
  echo "waiting for Integration server to come up..."
  sleep 5
done

declare -i usersNo=${MIN_USERS_NO:-2}
declare -i usersInc=${USER_NO_INCREMENT:-2}
declare -i maxUsersNo=${MAX_USERS_NO:-8}

declare -i loopCount=${LOOP_COUNT:-20}
declare -i slowMultiplier=${SLOW_MULTIPLIER:-200}
declare -i longLoopCount=${loopCount}*200

declare -i fastMillis=${FAST_MILLIS:-10}
declare -i slowMillis=${fastMillis}*${slowMultiplier}

declare -i minBigBodyBytes=${MIN_BIG_BODY_BYTES:-10000}
declare -i bigBodyBytesIncrement=${BIG_BODY_BYTES_INCREMENT:-25000}
declare -i maxBigBodyBytes=${MAX_BIG_BODY_BYTES:-300000}

echo "Test parameters:"
echo "loopCount=${loopCount}"
echo "slowMultiplier=${slowMultiplier}"
echo "longLoopCount=${longLoopCount}"
echo "fastMillis=${fastMillis}"
echo "slowMillis=${slowMillis}"
#echo "=${}"

while [ ${usersNo} -le ${maxUsersNo} ]; do
  echo "Running tests with ${usersNo} users"

  declare -i crtBigBodySize=${minBigBodyBytes}
  while [ ${crtBigBodySize} -le ${maxBigBodyBytes} ]; do
    echo "Running tests with ${usersNo} users with ${crtBigBodySize} big service body size"
    jmeter -n \
      -JserviceHostname=msr-test-01 \
      -JservicePort=5555 \
      -JserviceAdminPassword=${IS_ADMIN_PWD} \
      -JnoOfUsers=${usersNo} \
      -JloopCount=${loopCount} \
      -JquickThreadGroup.loopCount=${longLoopCount} \
      -JfastServiceSleepTime=${fastMillis} \
      -JslowServiceSleepTime=${slowMillis} \
      -JfastServiceBodyChars=48 \
      -JslowServiceBodyChars=${crtBigBodySize} \
      -Jprometheus.ip=0.0.0.0 \
      -t /tmp/suite.jmx

    sleep 30
    declare -i crtBigBodySize+=${bigBodyBytesIncrement}
  done 
  declare -i usersNo+=${usersInc}
done

echo "tests completed"
