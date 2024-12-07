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

##### BGP (optional)

You can set these parameter under `bgp` key parameter of `me`:

- `router-id`: BGP router-id
- `default-ipv4`: can be true or false (e.g: `no bgp default ipv4-unicast`)
- `default-ipv6`: can be true or false (e.g: `no bgp default ipv6-unicast`)
- `enforce-first-as`: can be true or false (e.g: `no bgp enforce-first-as`)
- `suppress-fib-pending`: can be true or false (e.g: `no bgp suppress-fib-pending`)
- `graceful-restart`: can be true or false (e.g: `no bgp graceful-restart`)
- `import-check`: can be true or false (e.g: `no bgp network import-check`)

#### RPKI

Here are the `rpki` parameters:

- `type`: for now, it only can be `tcp`
- `server`: IP address of the rpki server
- `port`: port number

#### Community

Here are the `community` parameters:

- `blackhole`: blackhole community
- `no-export`: no-export community
- `my-prefix`: (optional) Community tag of your own prefixes

##### Communities of Upstream, IXP, Peers, and Downstream

You can set these parameter under `upstream`, `ixp`, `downstream`, `peers` of `community`:

- `adv_only`: Only advertise to specific group
- `adv_no_export`: Advertise to group category with no-export

##### Local Preferences by Community

You have 4 default standard communities with an additional extended
to least significant 3 digits of the community:

```sh
bgp large-community-list standard CMS_PREFMOD_100 permit your_as:1:2100
bgp large-community-list standard CMS_PREFMOD_200 permit your_as:1:2200
bgp large-community-list standard CMS_PREFMOD_300 permit your_as:1:2300
bgp large-community-list standard CMS_PREFMOD_400 permit your_as:1:2400
bgp large-community-list expanded CME-PREFMOD_RANGE permit your_as:1:2...
```

##### Informational Communities

You have 5 informational communities:

```sh
bgp large-community-list standard CMS_LEARNT_UPSTREAM permit your_as:1:3000
bgp large-community-list standard CMS_LEARNT_DS permit your_as:1:3100
bgp large-community-list standard CMS_LEARNT_PEER permit your_as:1:3200
bgp large-community-list standard CMS_LEARNT_IXP permit your_as:1:3300
```

#### Upsteam and IXP

Add each peer configuration as a list. Here are the possible parameters for each `upstream` and `ixp`:

- key: Peer ASN (example: AS214145)
- `description`: ASN Name

#### Peers and Downstream

Add each peer configuration as a list. Here are the possible parameters for each `peers` and `downstream`:

- key: Peer ASN (example: AS214145)
- `description`: ASN Name
- `as-set`: AS-SET name (You can set an empty AS-SET if you want like: AS214145:AS-EMPTY)
- `max-prefix`: Peer maximum number of prefixes that you want to receive
- `addpath_tx_all_paths`: (optional) can be true or false.

#### Shared Value Between upstream, ixp, downstream, and peers key

For each peer configuration, optionally you can specify these parameters below:

- `neighbors`: (optional) List of neighbor IP addresses
- `upd-src`: (optional) Source IP address of your BGP
- `disable-connected-check`: (optional) can be true or false (e.g: `neighbor ASx disable-connected-check`).  (except for IXP peers)
- `ebgp-multihop`: (optional) TTL value of BGP Packets (except for IXP peers)

Note: `disable-connected-check` and `ebgp-multihop` will not apply to IXP peers

##### Communities and Local Preference

For each peer configuration, optionally you can specify a local preference and a community tag for valid and notfound RPKIs.
For example:

```yaml
config:
  upstream:
    AS6939:
      description: HE
      valid:
        loc: 200
        community: 2:501
      notfound:
        loc: 100
        community: 2:511
```

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
- `CME` as Community List Extended
- `CMS` as Community List Standard

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

**Note**: We are only using large communities to support 4-Byte ASN.

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
- We use `flt` as abbriviation for filter.
- We use `ups` as abbriviation for upstream.

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
  - `cfg`: Configuration File
  - `bgp`: BGP
  - `pfl`: Prefix-List
  - `asp`: AS-Path
  - `frr`: Frrouting
  - `rtm`: Route-Map
  - `cml`: Community Lists
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
