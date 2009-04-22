NAME=		openresolv
VERSION=	3.2
PKG=		${NAME}-${VERSION}

INSTALL?=	install
SED?=		sed
#PREFIX?=	/usr/local
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
SUBSCRIBERS=	libc dnsmasq named pdns_recursor
TARGET=		${RESOLVCONF} ${SUBSCRIBERS}

# Try to embed correct service restart commands
_CMD1=		\\1 status >/dev/null 2>\\&1
_CMD2=		\\1 restart
_CMD_SH=if [ -x /sbin/rc-service ]; then \
		printf '/sbin/rc-service \\1 -- -Ds restart'; \
	elif [ -x /sbin/service ]; then \
		printf '/sbin/service \\1 restart'; \
	elif [ -d /usr/local/etc/rc.d ]; then \
		printf 'if /usr/local/etc/rc.d/${_CMD1}; then'; \
		printf ' /usr/local/etc/rc.d/${_CMD2}; '; \
		printf 'elif /etc/rc.d/${_CMD1}; then /etc/rc.d/${_CMD2}; fi'; \
	elif [ -d /etc/rc.d ]; then \
		printf '/etc/rc.d/${_CMD1} \\&\\& /etc/rc.d/${_CMD2}'; \
	elif [ -d /etc/init.d ]; then \
		printf '/etc/init.d/${_CMD1} \\&\\& /etc/init.d/${_CMD2}'; \
	fi;
_CMD!=		${_CMD_SH}
RESTARTCMD?=	${_CMD}$(shell ${_CMD_SH})

.SUFFIXES: .in

all: ${TARGET}

.in:
	${SED} -e 's:@PREFIX@:${PREFIX}:g' \
		-e 's:@SYSCONFDIR@:${SYSCONFDIR}:g' \
		-e 's:@LIBEXECDIR@:${LIBEXECDIR}:g' \
		-e 's:@VARDIR@:${VARDIR}:g' \
		-e 's:@RESTARTCMD \(.*\)@:${RESTARTCMD}:g' \
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
