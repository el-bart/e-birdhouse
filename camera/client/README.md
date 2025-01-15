# camera client

to install create `inventory.yaml`, with `[all]` group.
add host(s) to be provisioned there.

copy `group_vars/all.yaml.template` as `group_vars/all.yaml.template` and configure IPs for your network.
this can also be done via `host_vars/foobar.yaml` for `foobar` host.

run:
```
ansible configure.yaml
```
