# openresolv

openresolv is a resolvconf(8) implementation which manages `/etc/resolv.conf`.

`/etc/resolv.conf` is a file that holds the configuration for the local
resolution of domain names.
Normally this file is either static or maintained by a local daemon,
normally a DHCP daemon. But what happens if more than one thing wants to
control the file?
Say you have wired and wireless interfaces to different subnets and run a VPN
or two on top of that, how do you say which one controls the file?
It's also not as easy as just adding and removing the nameservers each client
knows about as different clients could add the same nameservers.

Enter resolvconf, the middleman between the network configuration services and
`/etc/resolv.conf`.
resolvconf itself is just a script that stores, removes and lists a full
`resolv.conf` generated for the interface. It then calls all the helper scripts
it knows about so it can configure the real `/etc/resolv.conf` and optionally
any local nameservers other than libc.

## Why openresolv?

This resolvconf implementation, along with its subscribers, work with a
POSIX compliant shell and userland utilities. It is designed to work without
tools such as sed as it *has* to work without /usr being available.

On systems where resolvconf is expected to be used before /var/run is available
for writing, you can configure openresolv to write somewhere else, like say a
ramdisk.
