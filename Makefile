# Created by: Tomas Hecker <tomas.hecker@gmail.com>
# $FreeBSD$

PORTNAME=	opendistroforelasticsearch-kibana
PORTVERSION=	1.4.0
CATEGORIES=	textproc www
MASTER_SITES=	https://d3g5vo6xdbdb9a.cloudfront.net/tarball/opendistroforelasticsearch-kibana/

MAINTAINER=	tomas.hecker@gmail.com
COMMENT=	Apache 2.0-licensed Browser based analytics and search interface to ElasticSearch

LICENSE=	APACHE20

RUN_DEPENDS=	node10>=10.15.2:www/node10

CONFLICTS=	kibana[3-5]*

WRKSRC=		${WRKDIR}/${PORTNAME}

NO_BUILD=	yes
USE_RC_SUBR=	kibana
WWWDIR=		${PREFIX}/www/${USE_RC_SUBR}
ETCDIR=         ${PREFIX}/etc/${USE_RC_SUBR}

SUB_FILES=	pkg-deinstall
SUB_LIST+=	PORTNAME=${PORTNAME} PKGNAMESUFFIX=${PKGNAMESUFFIX}

post-patch:
	${FIND} -s ${WRKSRC}/node_modules -type d -empty -delete

do-install:
	${MKDIR} ${STAGEDIR}${WWWDIR} ${STAGEDIR}${ETCDIR}
	${INSTALL_DATA} ${WRKSRC}/config/kibana.yml ${STAGEDIR}${ETCDIR}/kibana.yml.sample
	(cd ${WRKSRC} && \
		${RM} -r config node optimize && \
		${COPYTREE_SHARE} . ${STAGEDIR}${WWWDIR} && \
		${COPYTREE_BIN} bin ${STAGEDIR}${WWWDIR})
	${INSTALL} -lrs ${STAGEDIR}${ETCDIR} ${STAGEDIR}${WWWDIR}/config

post-install:
	${ECHO} "@sample ${ETCDIR}/kibana.yml.sample" >> ${TMPPLIST}
	${FIND} -s ${STAGEDIR}${WWWDIR} -not -type d | ${SORT} | \
		${SED} -e 's#^${STAGEDIR}${PREFIX}/##' >> ${TMPPLIST}
	${ECHO} "@dir(www,www) ${WWWDIR}/data" >> ${TMPPLIST}
	${ECHO} "@dir ${WWWDIR}/plugins" >> ${TMPPLIST}

.include <bsd.port.mk>
