# Default behavior when running 'just' without input
default:
  @just --choose

# Updates the Ansible requirements
update:
  @ansible-galaxy install -r requirements.yml -f -vv

# Runs molecule testing with inputs
test *INPUTS:
  @molecule test {{INPUTS}}

# Tests all scenarios
test-all:
  @just test --all

# Tests only the archive installation scenario
test-archive:
  @just test --scenario-name install-archive -- --extra-vars "@../../molecule/install-archive/input-data.yml"
