# camera client

to install create `inventory.yaml`, with `[all]` group.
add host(s) to be provisioned there.

edit `group_vars/all.yaml` to configure `port` and `netroot` elements for your network.
this can also be done via `host_vars/foobar.yaml` for `foobar` host.

run:
```
ansible configure.yaml
```
