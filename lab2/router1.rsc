# mar/05/2023 16:40:01 by RouterOS 7.7
# software id = 
#
/interface bridge
add name=Loopback
/interface ovpn-client
add certificate=mikrotik.crt_0 connect-to=158.160.31.94 mac-address=\
    02:E5:BA:C0:24:0D name=ovpn-out1 user=mikrotik
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing id
add disabled=no id=172.16.1.1 name=OSPF_ID select-dynamic-id=""
/routing ospf instance
add disabled=no name=ospf-instance-1 originate-default=always router-id=\
    OSPF_ID
/routing ospf area
add disabled=no instance=ospf-instance-1 name=Backbone
/ip address
add address=172.16.1.1 interface=Loopback network=172.16.1.1
/ip dhcp-client
add interface=ether1
/ip ssh
set allow-none-crypto=yes always-allow-password-login=yes forwarding-enabled=\
    both
/routing ospf interface-template
add area=Backbone disabled=no interfaces=Loopback passive type=ptp
add area=Backbone disabled=no interfaces=ether1
/system ntp client
set enabled=yes
/system ntp client servers
add address=0.ru.pool.ntp.org
