# Cloudflare IPv6 installer (jbetkowski)
# Downloads from:
# https://raw.githubusercontent.com/jbetkowski/mikrotik-script-cloudflare-iplist/main/cf-ips-v6.rsc

# Script to download the Cloudflare list (v6)
/system script add name="jb-cloudflare-download-v6" source={
  :log info "Download Cloudflare IP list (v6) - jbetkowski";
  /tool fetch url="https://raw.githubusercontent.com/jbetkowski/mikrotik-script-cloudflare-iplist/main/cf-ips-v6.rsc" mode=https dst-path=cf-ips-v6.rsc check-certificate=yes;
}

# Script to replace/import the Cloudflare list (v6)
/system script add name="jb-cloudflare-replace-v6" source={
  :log info "Remove current Cloudflare IPs (v6)";
  /ipv6 firewall address-list remove [find where list="cloudflare-ips" and comment="CF"];
  :log info "Import newest Cloudflare IPs (v6)";
  /import file-name=cf-ips-v6.rsc;
}

# Initialize the scheduler with the scripts
/system scheduler
add interval=1d name="jb-cf-dl-v6" start-date=Jan/01/2000 start-time=03:30:00 on-event=jb-cloudflare-download-v6
add interval=1d name="jb-cf-rp-v6" start-date=Jan/01/2000 start-time=03:35:00 on-event=jb-cloudflare-replace-v6
