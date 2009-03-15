NAME=		openresolv
VERSION=	2.1.1
PKG=		${NAME}-${VERSION}

INSTALL?=	install
PREFIX?=	/usr/local
MANPREFIX?=	/usr/share
VARBASE?=	/var

BINMODE?=	0755
DOCMODE?=	0644
MANMODE?=	0444

SYSCONFDIR?=	${PREFIX}/etc/resolvconf
BINDIR=		${PREFIX}/sbin
LIBEXECDIR?=	${PREFIX}/libexec/resolvconf
MANDIR?=	${MANPREFIX}/man

RESOLVCONF=	resolvconf resolvconf.8
SUBSCRIBERS=	libc dnsmasq named
TARGET=		${RESOLVCONF} ${SUBSCRIBERS}

.SUFFIXES: .in

all: ${TARGET}

.in:
	sed -e 's:@PREFIX@:${PREFIX}:g' \
		-e 's:@SYSCONFDIR@:${SYSCONFDIR}:g' \
		-e 's:@LIBEXECDIR@:${LIBEXECDIR}:g' \
		-e 's:@VARBASE@:${VARBASE}:g' \
		$@.in > $@

clean:
	rm -f ${TARGET} openresolv-${VERSION}.tar.bz2

installdirs:

install: ${TARGET}
	${INSTALL} -d ${DESTDIR}${BINDIR}
	${INSTALL} -m ${BINMODE} resolvconf ${DESTDIR}${BINDIR}
	${INSTALL} -d ${DESTDIR}${LIBEXECDIR}
	${INSTALL} -m ${BINMODE} ${SUBSCRIBERS} ${DESTDIR}${LIBEXECDIR}
	${INSTALL} -d ${DESTDIR}${MANDIR}/man8
	${INSTALL} -m ${MANMODE} resolvconf.8 ${DESTDIR}${MANDIR}/man8

dist:
	${INSTALL} -d /tmp/${PKG}
	cp -RPp . /tmp/${PKG}
	(cd /tmp/${PKG}; ${MAKE} clean)
	rm -rf /tmp/${PKG}/*.bz2 /tmp/${PKG}/.svn
	tar cvjpf ${PKG}.tar.bz2 -C /tmp ${PKG} 
	rm -rf /tmp/${PKG} 
	ls -l ${PKG}.tar.bz2
