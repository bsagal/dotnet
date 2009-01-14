# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/xsp/xsp-2.0.ebuild,v 1.3 2008/11/27 18:46:27 ssuominen Exp $

EAPI=2

inherit go-mono mono

DESCRIPTION="XSP ASP.NET host"
HOMEPAGE="http://www.go-mono.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}"

pkg_preinst() {
	enewgroup aspnet

	# Give aspnet home dir of /tmp since it must create ~/.wapi
	enewuser aspnet -1 -1 /tmp aspnet
}

src_prepare() {
	go-mono_src_prepare
	sed -i -e 's:mono-nunit:nunit:' \
		unittests/Tests.XSP.Security/Makefile.in || die
}

src_compile() {
	emake -j1  || {
		echo
		eerror "If xsp fails to build, try unmerging and re-emerging it."
		die "make failed"
	}
}

src_install() {
	mv_command="cp -ar"
	go-mono_src_install

	newinitd "${FILESDIR}"/2.0/xsp.initd xsp || die
	newinitd "${FILESDIR}"/2.0/mod-mono-server.initd mod-mono-server || die
	newconfd "${FILESDIR}"/2.0/xsp.confd xsp || die
	newconfd "${FILESDIR}"/2.0/mod-mono-server.confd mod-mono-server || die

	keepdir /var/run/aspnet
}

pkg_postinst() {
	chown aspnet:aspnet /var/run/aspnet
}
