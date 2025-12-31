#!/usr/bin/env bash

ANSI_RED="31"
ANSI_YELLOW="33"
ANSI_CYAN="36"

SED_CMD=""
SED_CMD="${SED_CMD}s/INFO[^ ]* /\o033[01;${ANSI_CYAN}m&\o033[0m/;"
SED_CMD="${SED_CMD}s/WARN[^ ]* /\o033[01;${ANSI_YELLOW}m&\o033[0m/;"
SED_CMD="${SED_CMD}s/ERROR[^ ]* /\o033[01;${ANSI_RED}m&\o033[0m/;"

sed "${SED_CMD}"
