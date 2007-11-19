NAME = openresolv
VERSION = 1.0
PKG = $(NAME)-$(VERSION)

DESTDIR =
PREFIX =
MANPREFIX ?= /usr/share
ROOT = $(DESTDIR)$(PREFIX)
ETCDIR = $(ROOT)/etc/resolvconf
MANDIR = $(MANPREFIX)/man/man8
BINDIR = $(ROOT)/sbin
VARDIR = $(DESTDIR)/var/run
UPDATEDIR = $(ETCDIR)/update.d

RESOLVCONF = resolvconf resolvconf.8
SUBSCRIBERS = libc dnsmasq named
TARGET = $(RESOLVCONF) $(SUBSCRIBERS)

INSTALL ?= install

.SUFFIXES: .in

all: $(TARGET)

.in:
	sed -e s':^PREFIX=.*:PREFIX="$(PREFIX)":' $@.in > $@

resolvconf.8: resolvconf.8.in
	sed -e 's:%%PREFIX%%:$(PREFIX):g' $@.in > $@

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
	$(INSTALL) -m 0644 resolvconf.8 $(MANDIR)
	ln -snf /var/run/resolvconf $(ETCDIR)/run

dist:
	$(INSTALL) -d /tmp/$(PKG)
	cp -RPp . /tmp/$(PKG)
	(cd /tmp/$(PKG); $(MAKE) clean)
	rm -rf /tmp/$(PKG)/*.bz2 /tmp/$(PKG)/.git
	tar cvjpf $(PKG).tar.bz2 -C /tmp $(PKG) 
	rm -rf /tmp/$(PKG) 
	ls -l $(PKG).tar.bz2
