#!/bin/bash

echo "Checking if IS is up..."

while ! nc -z msr-test-01 5555 ; do
  echo "waiting for Integration server to come up..."
  sleep 5
done

declare -i usersNo=0
declare -i loopCount=${LOOP_COUNT:-20}
declare -i slowMultiplier=${SLOW_MULTIPLIER:-200}
declare -i longLoopCount=${loopCount}*200
declare -i fastMillis=${FAST_MILLIS:-10}
declare -i slowMillis=${fastMillis}*${slowMultiplier}

echo "Test parameters:"
echo "loopCount=${loopCount}"
echo "slowMultiplier=${slowMultiplier}"
echo "longLoopCount=${longLoopCount}"
echo "fastMillis=${fastMillis}"
echo "slowMillis=${slowMillis}"
#echo "=${}"

for i in {1..4}; do

  declare -i usersNo+=$i

  echo "running tests with ${usersNo} users"

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
    -JslowServiceBodyChars=500000 \
    -t /tmp/suite.jmx

  sleep 20
done

echo "tests completed"
