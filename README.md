# LIR Management

## 📖 Documentation

-----

We do have a man page `lirctl(8)`. Please read the following manual.

### Configuration File

The `lirctl.yaml` configuration file can be in these directories and it loaded by this order:

- `$HOME/.config/lirctl/lirctl.yaml`
- `/usr/local/etc/lirctl/lirctl.yaml`
- `/etc/lirctl/lirctl.yaml`

### Sample cron output

To update the as path lists, prefix lists, and the route-maps, use `lirctl cron update`.

To generate the full configuration (with bgp neighborships), use `lirctl cron full`.

## Contributions

Any PR(s) are welcomed.
Check the wiki section of Github for more information.
