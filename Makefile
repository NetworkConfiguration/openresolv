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

RESOLVCONF = resolvconf resolvconf.8
SUBSCRIBERS = libc dnsmasq named
TARGET = $(RESOLVCONF) $(SUBSCRIBERS)

all: $(TARGET)

$(SUBSCRIBERS): $*.in
	sed -e s':^PREFIX=.*:PREFIX="$(PREFIX)":' $*.in > $*

resolvconf: $*.in
	sed -e s':^PREFIX=.*:PREFIX="$(PREFIX)":' $*.in > $*

resolvconf.8:
	sed -e 's:%%PREFIX%%:$(PREFIX):g' $*.in > $*

clean:
	rm -f $(TARGET) openresolv-$(VERSION).tar.bz2

install: $(TARGET)
	$(INSTALL) -d $(BINDIR)
	$(INSTALL) -d $(VARDIR)/resolvconf
	$(INSTALL) resolvconf $(BINDIR)
	$(INSTALL) -d $(MANDIR)
	$(INSTALL) -d $(ETCDIR)/resolv.conf.d
	$(INSTALL) -d $(ETCDIR)/update-libc.d
	$(INSTALL) -d $(UPDATEDIR)
	$(INSTALL) $(SUBSCRIBERS) $(UPDATEDIR)
	$(INSTALL) -m 644 resolvconf.8 $(MANDIR)
	ln -snf /var/run/resolvconf $(ETCDIR)/run

dist:
	$(INSTALL) -m 0755 -d /tmp/openresolv-$(VERSION)
	cp -RPp . /tmp/openresolv-$(VERSION)
	(cd /tmp/openresolv-$(VERSION); $(MAKE) clean)
	rm -rf /tmp/openresolv-$(VERSION)/*.bz2 /tmp/openresolv-$(VERSION)/.git
	tar cvjpf openresolv-$(VERSION).tar.bz2 -C /tmp openresolv-$(VERSION)
	rm -rf /tmp/openresolv-$(VERSION)
	ls -l openresolv-$(VERSION).tar.bz2
