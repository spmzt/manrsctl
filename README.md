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

### Sample cron output

#### Updating Filters

To update the as path lists, prefix lists, and the route-maps, use `lirctl cron update`.

#### Full BGP Configuration

To generate the full configuration (with bgp neighborships), use `lirctl cron full`.

```sh
no ipv6 prefix-list IMPORT_IPV6_FROM_AS214145
ipv6 prefix-list IMPORT_IPV6_FROM_AS214145 permit 2a01:e140::/43 ge 44 le 44
ipv6 prefix-list IMPORT_IPV6_FROM_AS214145 permit 2a01:e140::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS214145 permit 2a01:e140:2::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS214145 permit 2a01:e140:a::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS214145 permit 2a01:e140:10::/48

ipv6 prefix-list EXPORT_IPV6_NETWORK description my IPv6 prefixes that we want to advertise
ipv6 prefix-list EXPORT_IPV6_NETWORK seq 10 permit 2001:db8::/48
ipv6 prefix-list EXPORT_IPV6_NETWORK seq 20 permit 2001:db8::/44

ipv6 prefix-list ANY_IPV6 description ALL IPv6 ranges
ipv6 prefix-list ANY_IPV6 seq 10 permit any

bgp as-path access-list ANY_ASN permit .*

bgp as-path access-list BOGON_ASN seq 5 deny _0_
bgp as-path access-list BOGON_ASN seq 10 deny _23456_
bgp as-path access-list BOGON_ASN seq 15 deny _6449[6-9]_
bgp as-path access-list BOGON_ASN seq 20 deny _64[5-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 25 deny _6[5-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 30 deny _[7-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 35 deny _1[0-2][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 40 deny _130[0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 45 deny _1310[0-6][0-9]_
bgp as-path access-list BOGON_ASN seq 50 deny _13107[0-1]_
bgp as-path access-list BOGON_ASN seq 55 deny _45875[2-9]_
bgp as-path access-list BOGON_ASN seq 60 deny _4587[6-9][0-9]_
bgp as-path access-list BOGON_ASN seq 65 deny _458[8-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 70 deny _459[0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 75 deny _4[6-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 80 deny _[5-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 85 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 90 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 95 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 100 deny _[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_
bgp as-path access-list BOGON_ASN seq 105 permit .*

no ipv6 prefix-list IMPORT_IPV6_FROM_AS27500
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:4:112::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:500:3::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:500:11::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:500:86::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:500:88::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:500:8c::/46 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:500:9c::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:500:9e::/47
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:500:9f::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:678:1::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:678:7::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:678:f::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:678:10::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:1201::/43 ge 44 le 44
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:1201::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:1201:10::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:1258::/32
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:12f8:8::/47 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:1398:121::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:1398:275::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:13c7:7000::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:1488::/32
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:148f:fffb::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2001:148f:fffd::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2602:800:9004::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2602:800:9007::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2602:800:900e::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2620:0:2d0::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2620:0:22b0::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2620:0:2830::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2620:0:2ed0::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2620:0:2ee0::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2620:f:8000::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2620:4f:8000::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2620:10a:80ba::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2801:c4:c0::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2801:c4:d0::/44
ipv6 prefix-list IMPORT_IPV6_FROM_AS27500 permit 2801:c4:d0::/48

no ip as-path access-list IMPORT_ASN_FROM_AS27500
ip as-path access-list IMPORT_ASN_FROM_AS27500 permit ^27500(_27500)*$
ip as-path access-list IMPORT_ASN_FROM_AS27500 permit ^27500(_[0-9]+)*_(112|10906|16876|20144)$
ip as-path access-list IMPORT_ASN_FROM_AS27500 permit ^27500(_[0-9]+)*_(25192|26710|26711|27661)$
ip as-path access-list IMPORT_ASN_FROM_AS27500 permit ^27500(_[0-9]+)*_(28498|28499|28500|28510)$
ip as-path access-list IMPORT_ASN_FROM_AS27500 permit ^27500(_[0-9]+)*_(28540|40528|48053|52304)$
ip as-path access-list IMPORT_ASN_FROM_AS27500 permit ^27500(_[0-9]+)*_(52306)$

no ipv6 prefix-list IMPORT_IPV6_FROM_AS2121
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:67c:64::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:67c:2e8::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ee00::/46 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ee04::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ef00::/46 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ef04::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fd02::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fd05::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fe00::/45 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fe0a::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fe0c::/46 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fe10::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fe12::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fe14::/46 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fe18::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:fe20::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ff00::/45 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ff0a::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ff0c::/46 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ff10::/48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ff12::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ff14::/46 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ff18::/47 ge 48 le 48
ipv6 prefix-list IMPORT_IPV6_FROM_AS2121 permit 2001:7fb:ff20::/48

no ip as-path access-list IMPORT_ASN_FROM_AS2121
ip as-path access-list IMPORT_ASN_FROM_AS2121 permit ^2121(_2121)*$
ip as-path access-list IMPORT_ASN_FROM_AS2121 permit ^2121(_[0-9]+)*_(3333|12654)$

route-map IMPORT_RTMV6_FROM_AS27500 permit 10
 description Import any valid RPKI from 27500
 match rpki valid
 match ipv6 address prefix-list ANY_IPV6
 match as-path ANY_ASN
 match as-path BOGON_ASN
 set local-preference 30
exit
!
route-map IMPORT_RTMV6_FROM_AS27500 permit 15
 description Import any prefix that not found in RPKI db from 27500 with lower pref
 match rpki notfound
 match ipv6 address prefix-list ANY_IPV6
 match as-path ANY_ASN
 match as-path BOGON_ASN
 set local-preference 20
exit
!
route-map IMPORT_RTMV6_FROM_AS27500 deny 20
 description Reject any prefix that is not valid in RPKI db from 27500
 match rpki invalid
exit
!
route-map IMPORT_RTMV6_FROM_AS27500 deny 99
 description Reject any prefix from 27500
 match ipv6 address prefix-list ANY_IPV6
exit

route-map EXPORT_RTMV6_TO_AS27500 permit 10
 description Export netwroks with valid RPKI
 match ipv6 address prefix-list EXPORT_IPV6_FROM_AS27500
 match ipv6 address prefix-list EXPORT_IPV6_NETWORK
 match rpki valid
exit
!
route-map EXPORT_RTMV6_TO_AS27500 deny 99
 description Export netwroks with specific BGP attributes
 match ipv6 address prefix-list ANY_IPV6
exit

route-map IMPORT_RTMV6_FROM_AS2121 permit 10
 description Import any valid RPKI from 2121
 match rpki valid
 match ipv6 address prefix-list IMPORT_IPV6_FROM_AS2121
 match as-path IMPORT_ASN_FROM_AS2121
 match as-path BOGON_ASN
 set local-preference 30
exit
!
route-map IMPORT_RTMV6_FROM_AS2121 permit 15
 description Import any prefix that not found in RPKI db from 2121 with lower pref
 match rpki notfound
 match ipv6 address prefix-list IMPORT_IPV6_FROM_AS2121
 match as-path IMPORT_ASN_FROM_AS2121
 match as-path BOGON_ASN
 set local-preference 20
exit
!
route-map IMPORT_RTMV6_FROM_AS2121 deny 20
 description Reject any prefix that is not valid in RPKI db from 2121
 match rpki invalid
exit
!
route-map IMPORT_RTMV6_FROM_AS2121 deny 99
 description Reject any prefix from 2121
 match ipv6 address prefix-list ANY_IPV6
exit

route-map EXPORT_RTMV6_TO_AS2121 permit 10
 description Export netwroks with valid RPKI
 match ipv6 address prefix-list EXPORT_IPV6_FROM_AS2121
 match ipv6 address prefix-list EXPORT_IPV6_NETWORK
 match rpki valid
exit
!
route-map EXPORT_RTMV6_TO_AS2121 deny 99
 description Export netwroks with specific BGP attributes
 match ipv6 address prefix-list ANY_IPV6
exit

router bgp 214145
neighbor AS27500 peer-group
neighbor AS27500 remote-as 27500
address-family ipv6 unicast
  neighbor AS27500 remove-private-AS
  neighbor AS27500 soft-reconfiguration inbound
  neighbor AS27500 route-map IMPORT_RTMV6_FROM_AS27500 in
  neighbor AS27500 route-map EXPORT_RTMV6_TO_AS27500 out
  neighbot AS27500 filter-list ANY_ASN in
  neighbot AS27500 prefix-list ANY_IPV6 in
  neighbot AS27500 prefix-list EXPORT_IPV6_TO_AS27500 out
  neighbot AS27500 maximum-prefix-out 10
  neighbor AS27500 activate
  exit
exit

router bgp 214145
neighbor AS2121 peer-group
neighbor AS2121 remote-as 2121
address-family ipv6 unicast
  neighbor AS2121 remove-private-AS
  neighbor AS2121 soft-reconfiguration inbound
  neighbor AS2121 route-map IMPORT_RTMV6_FROM_AS2121 in
  neighbor AS2121 route-map EXPORT_RTMV6_TO_AS2121 out
  neighbot AS2121 filter-list IMPORT_ASN_FROM_AS2121 in
  neighbot AS2121 prefix-list IMPORT_IPV6_FROM_AS2121 in
  neighbot AS2121 prefix-list EXPORT_IPV6_TO_AS2121 out
  neighbot AS2121 maximum-prefix-out 10
  neighbor AS2121 activate
  exit
exit
```

## Contributions

Any PR(s) are welcomed.
Check the wiki section of Github for more information.
