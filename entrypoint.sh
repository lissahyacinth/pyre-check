#! /bin/bash -l
set -uo pipefail
pyre $@ . check
