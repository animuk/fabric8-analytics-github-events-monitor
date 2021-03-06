#!/bin/bash

set -ex

prep() {
    yum -y update
    yum -y install epel-release https://centos7.iuscommunity.org/ius-release.rpm
    yum -y install python36u which
}

prep
./detect-common-errors.sh
./detect-dead-code.sh
./measure-cyclomatic-complexity.sh --fail-on-error
./measure-maintainability-index.sh --fail-on-error
./run-linter.sh
