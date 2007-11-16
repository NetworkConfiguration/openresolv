VERSION = 1.0
DESTDIR =
PREFIX =
MANPREFIX ?= /usr/share
ROOT = $(DESTDIR)$(PREFIX)
INSTALL = install 
ETCDIR = $(ROOT)/etc/resolvconf
MANDIR = $(MANPREFIX)/man/man8
BINDIR = $(ROOT)/sbin
VARDIR = $(DESTDIR)/var/run
UPDATEDIR = $(ETCDIR)/update.d

.PHONY: all default clean

install:
	$(INSTALL) -d $(BINDIR)
	$(INSTALL) -d $(VARDIR)/resolvconf
	$(INSTALL) resolvconf $(BINDIR)
	$(INSTALL) -d $(MANDIR)
	$(INSTALL) -d $(ETCDIR)/resolv.conf.d
	$(INSTALL) -d $(ETCDIR)/update-libc.d
	$(INSTALL) -d $(UPDATEDIR)
	$(INSTALL) libc dnsmasq named $(UPDATEDIR)
	$(INSTALL) -m 644 resolvconf.8 $(MANDIR)
	if test "$(PREFIX)" "!=" "/" && test -n "$(PREFIX)"; then \
		for x in $(BINDIR)/resolvconf $(UPDATEDIR)/libc $(UPDATEDIR)/dnsmasq $(UPDATEDIR)/named; do \
		sed -i.bak -e s':^PREFIX=.*:PREFIX="$(PREFIX)":' "$$x"; rm "$$x".bak; \
		done; \
	fi;
	sed -i.bak -e 's:%%PREFIX%%:$(PREFIX):g' $(MANDIR)/resolvconf.8
	rm $(MANDIR)/resolvconf.8.bak
	ln -snf /var/run/resolvconf $(ETCDIR)/run

dist:
	$(INSTALL) -m 0755 -d /tmp/openresolv-$(VERSION)
	cp -RPp . /tmp/openresolv-$(VERSION)
	(cd /tmp/openresolv-$(VERSION); $(MAKE) clean)
	rm -rf /tmp/openresolv-$(VERSION)/*.bz2 /tmp/openresolv-$(VERSION)/.git
	tar cvjpf openresolv-$(VERSION).tar.bz2 -C /tmp openresolv-$(VERSION)
	rm -rf /tmp/openresolv-$(VERSION)
	ls -l openresolv-$(VERSION).tar.bz2
