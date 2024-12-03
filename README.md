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
- `max-prefix`: Your maximum number of prefixes that you plan to advertise
- `prefixes`: List of your current prefixes that you want to advertise

#### Upsteam and IXP

Add each peer configuration as a list. Here are the possible parameters for each `upstream` and `ixp`:

- key: Peer ASN (example: AS214145)
- `description`: ASN Name
- `neighbors`: (optional) List of neighbor IP addresses
- `update-source`: (optional) Source IP address of your BGP

#### Peers and Downstream

Add each peer configuration as a list. Here are the possible parameters for each `peers` and `downstream`:

- key: Peer ASN (example: AS214145)
- `description`: ASN Name
- `as-set`: AS-SET name
- `max-prefix`: Peer maximum number of prefixes that you want to receive
- `neighbors`: (optional) List of neighbor IP addresses
- `update-source`: (optional) Source IP address of your BGP

#### Configuration Example

Checkout `/usr/local/etc/lirctl/lirctl.conf.sample`.

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

#### Function Naming Precedence

Here is our naming standard:

```sh
${name}_${ass}_${ds}_${version}_${direction}_${rev}_${helper}_${result}
```

- result:
  - get: result of one function
  - list: result of multiple functions
  - check: result of verifications
- helper: name of helper file of function
  - cfg
  - bgp
  - pfl
  - asp
  - frr
  - rtm
- rev: (optional) is it reverse of another function?
- direction: (optional) in or out?
- version: (optional) is it ipv4 (defined as `_v4`) or not (empty)?
- ds: (optional) does it have any downstream (defined as `_ds`) or not (defined as `_ds_rev`)?
- ass: (optional) does it have any as-set (defined as `_ass`) or not (defined as `_ass_rev`)?
- name: simply name of function

### Todo

Add EDROP:

- <https://www.spamhaus.org/drop/drop_v6.json>
- <https://www.spamhaus.org/drop/drop_v4.json>
- <https://www.spamhaus.org/drop/asndrop.json>
