# Generated on 2026-01-02 08:15:38 UTC
/ipv6 firewall address-list
remove [find where list="cloudflare-ips" and comment="CF"]
add list="cloudflare-ips" address="2400:cb00::/32" comment="CF"
add list="cloudflare-ips" address="2606:4700::/32" comment="CF"
add list="cloudflare-ips" address="2803:f800::/32" comment="CF"
add list="cloudflare-ips" address="2405:b500::/32" comment="CF"
add list="cloudflare-ips" address="2405:8100::/32" comment="CF"
add list="cloudflare-ips" address="2a06:98c0::/29" comment="CF"
add list="cloudflare-ips" address="2c0f:f248::/32" comment="CF"
