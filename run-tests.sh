#!/usr/bin/bash

COVERAGE_THRESHOLD=90

TERM=${TERM:-xterm}

# set up terminal colors
NORMAL=$(tput sgr0)
RED=$(tput bold && tput setaf 1)
GREEN=$(tput bold && tput setaf 2)
YELLOW=$(tput bold && tput setaf 3)

function prepare_venv() {
	# we want tests to run on python3.6
	printf 'checking alias `python3.6` ... ' >&2
	PYTHON=$(which python3.6 2> /dev/null)
	if [ "$?" -ne "0" ]; then
		printf "%sNOT FOUND%s\n" "${YELLOW}" "${NORMAL}" >&2

		printf 'checking alias `python3` ... ' >&2
		PYTHON=$(which python3 2> /dev/null)

		let ec=$?
		[ "$ec" -ne "0" ] && printf "${RED} NOT FOUND ${NORMAL}\n" && return $ec
	fi

	printf "%sOK%s\n" "${GREEN}" "${NORMAL}" >&2

	${PYTHON} -m venv "venv" && source venv/bin/activate
}

[ "$NOVENV" == "1" ] || prepare_venv || exit 1


# install the project
pip install -r requirements.txt
pip install git+https://github.com/fabric8-analytics/fabric8-analytics-worker.git@561636c

# ensure pytest and coverage is available
pip install pytest pytest-cov

# run tests
pytest --cov="ghmonitor/" --cov-report term-missing --cov-fail-under=$COVERAGE_THRESHOLD -vv ghmonitor/ tests/ $@
