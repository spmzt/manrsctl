# MANRS Management

## 📖 Documentation

-----

We do have a man page `manrsctl(8)`. Please read the following manual.

### Configuration File

The `manrsctl.yaml` configuration file can be in these directories and it loaded by this order:

- `$HOME/.config/manrsctl/manrsctl.yaml`
- `/usr/local/etc/manrsctl/manrsctl.yaml`
- `/etc/manrsctl/manrsctl.yaml`

### Installation

To install `manrsctl(8)`:

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

Here are the `rpki` parameters, pass them as list:

- `precedence`: priority of server
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

- `3000`: learned from upstream (CMS_LEARNT_UPSTREAM)
- `3100`: learned from downstream (CMS_LEARNT_DS)
- `3200`: learned from peer (CMS_LEARNT_PEER)
- `3300`: learned from IXP (CMS_LEARNT_IXP)

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

#### Route-map and Community relationships

For `IXP`:

Import: `RTM_IMPORT_FROM_ASx`:

- 1. permit call `RTM_INVALID_DENY`
  - 1. deny if match rpki invalid
  - 2. deny if match `PFL_BOGON`
  - 3. deny if match `PFL_V4_BOGON`
  - 4. deny if match `ASP_REV_BOGON`
  - 99. permit
- 5. permit call `RTM_IXP_IN`
  - 10. permit call `RTM_CML_IN`
    - 10. permit if match `CMS_BLACKHOLE` then call `RTM_BLACKHOLE`
    - 20. permit if match `CMS_NO_EXPORT` then call `RTM_NO_EXPORT`
    - 30. permit if match `CME_PREFMOD_RANGE` then call `RTM_PREFMOD`
    - 40. permit
  - 20. permit set large-community `214145:1:3300 additive`
- 10. permit if match rpki valid AND `ASP_BOGON` then set local preference x.
- 20. permit if match rpki notfound AND `ASP_BOGON` then set local preference y.
- 99. deny if match `PFL_ANY`

Export: `RTM_EXPORT_TO_ASx`:

- 1. permit call `RTM_INVALID_DENY`
  - 1. deny if match rpki invalid
  - 2. deny if match `PFL_BOGON`
  - 3. deny if match `PFL_V4_BOGON`
  - 4. deny if match `ASP_REV_BOGON`
  - 99. permit
- 5. permit call `RTM_CML_FLT_TO_IXP`
  - 10. deny `CMS_UPS_ONLY`
  - 20. deny `CMS_DS_ONLY`
  - 30. deny `CMS_PEERS_ONLY`
  - 40. permit if match `CMS_IXP_NO_EXPORT` then call `RTM_NO_EXPORT`
  - 99. permit
- 10. permit if match rpki valid AND `PFL_EXPORT_FROM_ASy`.
- 20. permit if match rpki valid AND `CMS_LEARNT_DS`.
- 99. deny if match `PFL_ANY`

#### Configuration Example

Checkout `/usr/local/etc/manrsctl/manrsctl.conf.sample`.

### IPv6

#### Random Generator

To generate random host (/64) address:

```sh
manrsctl ipv6 rand
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

To update the as path lists, prefix lists, and the route-maps, use `manrsctl cron update`.

#### Updating Bogon Filters

To update the Bogon as-path lists, and prefix lists use `manrsctl cron bogon`.

#### Full BGP Configuration

To generate the full configuration (with bgp neighborships), use `manrsctl cron full`.

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
