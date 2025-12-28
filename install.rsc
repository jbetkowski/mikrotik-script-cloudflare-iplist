# Cloudflare IPv4 list installer (jbetkowski)
# Downloads and imports cf-ips-v4.rsc from:
# https://github.com/jbetkowski/mikrotik-script-cloudflare-iplist

# Script to download the Cloudflare list (IPv4)
/system script add name="jb-cloudflare-download" source={
  :log info "CF v4: download IP list from jbetkowski repo";
  /tool fetch url="https://raw.githubusercontent.com/jbetkowski/mikrotik-script-cloudflare-iplist/main/cf-ips-v4.rsc" mode=https dst-path=cf-ips-v4.rsc check-certificate=yes;
}

# Script to import the Cloudflare list (IPv4)
/system script add name="jb-cloudflare-import" source={
  :log info "CF v4: import newest IPs";
  /import file-name=cf-ips-v4.rsc;
}

# Initialize the scheduler with the scripts
/system scheduler
add interval=1d name="jb-cf-dl" start-date=Jan/01/2000 start-time=03:20:00 on-event=jb-cloudflare-download
add interval=1d name="jb-cf-im" start-date=Jan/01/2000 start-time=03:25:00 on-event=jb-cloudflare-import
