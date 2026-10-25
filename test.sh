#!/bin/sh

set -e

cleanup() {
  set +e

  echo "Logs"
  docker logs test

  echo "Stopping Docker image"
  docker stop test
  docker rm -f test
}

echo "Running Docker image"
docker run -d --name test -e LOG_TO_STDOUT=1 -p 80:80 "${CI_REGISTRY_IMAGE}:${TAG}"
trap cleanup EXIT

echo "Sleeping"
sleep 10

echo "Testing"
docker exec test test -s /var/lib/postfixadmin/postfixadmin.db
wget -T 30 -q -O - http://docker/postfixadmin/login.php | grep -q '<title>Postfix Admin'
wget -T 30 -q -O - http://docker/postfixadmin/css/bootstrap-3.4.1-dist/css/bootstrap.min.css | grep -q 'Bootstrap'
echo "Success"
