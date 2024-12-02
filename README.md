# LIR Management

## 📖 Documentation

-----

We do have a man page `lirctl(8)`. Please read the following manual.

### Configuration File

The `lirctl.yaml` configuration file can be in these directories and it loaded by this order:

- `$HOME/.config/lirctl/lirctl.yaml`
- `/usr/local/etc/lirctl/lirctl.yaml`
- `/etc/lirctl/lirctl.yaml`

### Installation

To install `lirctl(8)`:

```sh
sudo make install
```

### Uninstall

To uninstall:

```sh
sudo make uninstall
```


### Configuration

Under `config`, use `me` for your own AS information, and use `peers` for your peers' information.

#### me

Here are the `me` parameters:

- `number`: Your ASN
- `as-set`: Your downstream AS set
- `downstream`: Do you have any downstream? [yes/no]
- `max_prefix`: Your maximum number of prefixes that you plan to advertise
- `prefixes`: List of your current prefixes that you want to advertise

#### peers

Add each peer configuration as a list. Here are the possible parameters for each `peer`:

- `number`: Peer ASN
- `downstream`: Does your peer have any downstream? [yes/no]
- `as-set`: If the `downstream` is `yes`, does your peer have any downstream AS set?
- `is_my_upstream`: Is it your upstream?

#### Configuration Example

```yaml
config:
  me:
    number: 214145
    as-set: "AS214145:AS-BASE"
    downstream: no
    max_prefix: 10
    prefixes:
      - "2001:db8::/48"
      - "2001:db8::/44"
  peers:
    - number: 27500
      as-set: "AS-ICANN"
      downstream: yes
      is_my_upstream: yes
    - number: 2121
      as-set: "AS-RIPENCC"
      downstream: yes
      is_my_upstream: no
```

### IPv6

#### Random Generator

To generate random host (/64) address:

```sh
lirctl ipv6 rand
```

### Naming Standards

We use these suffixes:

- `PFL` as prefix-lists
- `RTM` as route-map
- `ASP` as as-path

### Communities

You can match communities we provide actions for, on routes receives from customers, IXP, and Upstream.

Communities values of 214145:1:X, with X, have actions:

- `1:100` - blackhole the prefix
- `1:200` - set no_export
- `1:300` - advertise only to other customers
- `1:400` - advertise only to ixp
- `1:500` - advertise only to upstreams
- `1:600` - set no_export when advertising to upstreams
- `1:2X00` - set local_preference to X00

### Usages

#### Updating Filters

To update the as path lists, prefix lists, and the route-maps, use `lirctl cron update`.

#### Updating Bogon Filters

To update the Bogon as-path lists, and prefix lists use `lirctl cron bogon`.

#### Full BGP Configuration

To generate the full configuration (with bgp neighborships), use `lirctl cron full`.

## Contributions

Any PR(s) are welcomed.
Check the wiki section of Github for more information.

### Coding Principles

- We refer to the `-lib.sh` files as libraries.
- We refer to the non-library files in the `lib` directory as helpers.
- We do not import helpers inside another helper.
- In helpers, we use `_get` for functions and `_list` for groups of functions.
- We define IPv4-specific codes as `_v4_`, but we do not define specific function names for IPv6-specific codes.
- We use `_ds_` in function names for those that have downstreams, and `_nods_` for those that don't have downstreams.

### Todo

Add EDROP:

- <https://www.spamhaus.org/drop/drop_v6.json>
- <https://www.spamhaus.org/drop/drop_v4.json>
- <https://www.spamhaus.org/drop/asndrop.json>
