#!/bin/bash

set -ex

parallel --jobs 32 "./create_vm.sh {}" ::: {1..10}
