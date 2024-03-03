# Ansible

## Prepare the execution environment

In case ansible-navigator is used, the execution environment can be
prepared with `ansible-builder build`. Otherwise, use
`execution-environment.yml` as reference for dependencies.

## Prepare the inventory

Replace the public DNS name in `hosts.yaml` by the one from the
terraform step.

## Execute the playbook

    ansible-navigator run -i hosts.yaml --user=ubuntu playbook.yaml

In case ansible-navigator shall not be used, replace “ansible-navigator
run” by “ansible-playbook”.

## Remarks

### Inventory

A dynamic AWS inventory to find the instance DNS name could have been
used. Since the focus was not on the cloud setup, a static inventory is
used for simplicity.

Only very few things are parametrized, since it was rarely necessary for
the standalone example. The approach is to keep things simple and change
them when it becomes necessary. (It actually is necessary for the scap
role :-) )

### VLAN configuration

The configuration of the internal interface with VLAN tagging is pure
“guesswork”. With AWS VPC as layer 2 it is not possible to test or use
it.

### Firewall

All firewall stuff is in one role, because ufw and ufw module are the
opposite of desired state. So things must be done in one consistent run.
Also this role goes to quite some stretch to get update of firewalls
right, producing a small unprotected time window as a side effect. In
general this should not be necessary since infrastructure is expected to
be immutable. Running systems shall never be changed, but only created
from scratch.

### Hardening

The security requirements are not explicitly specified. For “generic”
security it may be appropriate to refer to external generic sources. Two
possibilities are implemented.

1.  Use a defined security baseline from the SCAP project by doing a
    scan and producing a remediation playbook. This playbook in general
    needs inspection and adaption, so the process is not fully automated
    in this example.

2.  Use a hardening role from a galaxy collection. This is used mainly
    for Nginx hardening, since this is not covered by openscap. Mainly
    it is used to fix the infamous “server_tokens directive” issue.

    In general, directly using external code is problematic. It usually
    follows different style guides and conventions, pulls in unforeseen
    dependencies and rarely does exactly what is needed. In our case,
    the creation of the DH group takes sometimes half an hour, although
    it is not used in the setup.
