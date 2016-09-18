# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="Microsoft .NET Core - CoreFX native componets"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}

IUSE=""
SRC_URI="https://github.com/dotnet/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

SLOT="${PV}"
KEYWORDS="~amd64"

#need to check which deps are for coreclr and which are for corefx
RDEPEND="
	>=net-misc/curl-7.28.0
	>=app-crypt/mit-krb5-1.14.2
	>=dev-libs/icu-57.1
	>=sys-devel/llvm-3.7.1-r3[lldb]
	>=sys-libs/libunwind-1.1-r1
	>=dev-util/lttng-ust-2.8.1
	>=dev-libs/openssl-1.0.2h-r2
	>=sys-libs/zlib-1.2.8-r1
	>=sys-apps/util-linux-2.16"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.3.1-r1
	>=sys-devel/make-4.1-r1
	>=sys-devel/clang-3.7.1-r100
	>=sys-devel/gettext-0.19.7"

	
S="${WORKDIR}/${MY_P}"
	
src_compile() {
	./build.sh native x64 release || die
}

src_install() {
	local dest="/usr/share/dotnet/shared/corefx"
	local ddest="${D}/${dest}"

	dodir "${dest}"
	cp -pPR  "${S}/bin/Linux.x64.Release" "${ddest}/${PV}"
}
