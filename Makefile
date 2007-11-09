DESTDIR =
PREFIX = /
ROOT = $(DESTDIR)$(PREFIX)
INSTALL = install 
ETCDIR = $(ROOT)/etc/resolvconf
SHAREDIR = $(ROOT)/usr/share/man
MANDIR = $(SHAREDIR)/man8
BINDIR = $(ROOT)/sbin
VARDIR = $(DESTDIR)/var/run
UPDATEDIR = $(ETCDIR)/update.d

default:

install:
	$(INSTALL) -d $(ETCDIR)/resolv.conf.d
	$(INSTALL) -d $(UPDATEDIR)
	$(INSTALL) -d $(ETCDIR)/update-libc.d
	$(INSTALL) -d $(MANDIR)
	$(INSTALL) -d $(BINDIR)
	$(INSTALL) -d $(VARDIR)/resolvconf
	$(INSTALL) resolvconf $(BINDIR)
	$(INSTALL) libc $(UPDATEDIR)
	if test "$(PREFIX)" "!=" "/"; then \
		for x in $(BINDIR)/resolvconf $(UPDATEDIR)/libc; do \
		sed -i.bak -e s':^PREFIX=.*:PREFIX="$(PREFIX)":' "$$x"; rm "$$x".bak; \
		done; \
		fi;
	$(INSTALL) -m 644 resolvconf.8 $(MANDIR)
	ln -snf /var/run/resolvconf $(ETCDIR)/run
