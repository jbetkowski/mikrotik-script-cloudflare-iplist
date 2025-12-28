from __future__ import annotations

from datetime import datetime, UTC
import requests

CF_URL_V4 = "https://www.cloudflare.com/ips-v4"
CF_URL_V6 = "https://www.cloudflare.com/ips-v6"

LIST_NAME = "cloudflare-ips"
COMMENT_TAG = "CF"

OUT_V4 = "cf-ips-v4.rsc"
OUT_V6 = "cf-ips-v6.rsc"


def _fetch_lines(url: str) -> list[str]:
    r = requests.get(url, timeout=30)
    r.raise_for_status()
    return [ln.strip() for ln in r.text.splitlines() if ln.strip()]


def _write_rsc_ipv4(lines: list[str], out_file: str, generated: str) -> None:
    with open(out_file, "w", encoding="utf-8") as f:
        f.write(f"# Generated on {generated}\n")
        f.write("/ip firewall address-list\n")
        f.write(f"remove [find where list=\"{LIST_NAME}\" and comment=\"{COMMENT_TAG}\"]\n")
        for cidr in lines:
            f.write(f"add list=\"{LIST_NAME}\" address=\"{cidr}\" comment=\"{COMMENT_TAG}\"\n")


def _write_rsc_ipv6(lines: list[str], out_file: str, generated: str) -> None:
    with open(out_file, "w", encoding="utf-8") as f:
        f.write(f"# Generated on {generated}\n")
        f.write("/ipv6 firewall address-list\n")
        f.write(f"remove [find where list=\"{LIST_NAME}\" and comment=\"{COMMENT_TAG}\"]\n")
        for cidr in lines:
            f.write(f"add list=\"{LIST_NAME}\" address=\"{cidr}\" comment=\"{COMMENT_TAG}\"\n")


def main() -> None:
    generated = datetime.now(UTC).strftime("%Y-%m-%d %H:%M:%S UTC")
    v4 = _fetch_lines(CF_URL_V4)
    v6 = _fetch_lines(CF_URL_V6)

    print(f"{generated} - fetched v4={len(v4)} ranges, v6={len(v6)} ranges")

    _write_rsc_ipv4(v4, OUT_V4, generated)
    _write_rsc_ipv6(v6, OUT_V6, generated)


if __name__ == "__main__":
    main()
