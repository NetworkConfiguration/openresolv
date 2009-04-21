NAME=		openresolv
VERSION=	3.2
PKG=		${NAME}-${VERSION}

INSTALL?=	install
PREFIX?=	/usr/local
MANPREFIX?=	/usr/share
VARBASE?=	/var

BINMODE?=	0755
DOCMODE?=	0644
MANMODE?=	0444

SYSCONFDIR?=	${PREFIX}/etc
BINDIR=		${PREFIX}/sbin
LIBEXECDIR?=	${PREFIX}/libexec/resolvconf
VARDIR?=	${VARBASE}/run/resolvconf
MANDIR?=	${MANPREFIX}/man

RESOLVCONF=	resolvconf resolvconf.8 resolvconf.conf.5
SUBSCRIBERS=	libc dnsmasq named pdns-recursor
TARGET=		${RESOLVCONF} ${SUBSCRIBERS}

.SUFFIXES: .in

all: ${TARGET}

.in:
	sed -e 's:@PREFIX@:${PREFIX}:g' \
		-e 's:@SYSCONFDIR@:${SYSCONFDIR}:g' \
		-e 's:@LIBEXECDIR@:${LIBEXECDIR}:g' \
		-e 's:@VARDIR@:${VARDIR}:g' \
		$@.in > $@

clean:
	rm -f ${TARGET} openresolv-${VERSION}.tar.bz2

installdirs:

install: ${TARGET}
	${INSTALL} -d ${DESTDIR}${BINDIR}
	${INSTALL} -m ${BINMODE} resolvconf ${DESTDIR}${BINDIR}
	${INSTALL} -d ${DESTDIR}${SYSCONFDIR}
	${INSTALL} -m ${DOCMODE} resolvconf.conf ${DESTDIR}${SYSCONFDIR}
	${INSTALL} -d ${DESTDIR}${LIBEXECDIR}
	${INSTALL} -m ${BINMODE} ${SUBSCRIBERS} ${DESTDIR}${LIBEXECDIR}
	${INSTALL} -d ${DESTDIR}${MANDIR}/man8
	${INSTALL} -m ${MANMODE} resolvconf.8 ${DESTDIR}${MANDIR}/man8
	${INSTALL} -d ${DESTDIR}${MANDIR}/man5
	${INSTALL} -m ${MANMODE} resolvconf.conf.5 ${DESTDIR}${MANDIR}/man5

dist:
	${INSTALL} -d /tmp/${PKG}
	cp -RPp . /tmp/${PKG}
	(cd /tmp/${PKG}; ${MAKE} clean)
	rm -rf /tmp/${PKG}/*.bz2 /tmp/${PKG}/.svn
	tar cvjpf ${PKG}.tar.bz2 -C /tmp ${PKG} 
	rm -rf /tmp/${PKG} 
	ls -l ${PKG}.tar.bz2
