FROM centos:7
LABEL maintainer="Eliécer Tatés eliecer.tates@gmail.com"
#Install repo epel and other tools
RUN yum -y install --nogpgcheck epel-release yum-utils wget net-tools bind-utils ; \
\
#Install tucny repo for asterisk 13 and enable repos
	yum-config-manager --add-repo https://ast.tucny.com/repo/tucny-asterisk.repo ; \
	yum-config-manager --enable asterisk-common asterisk-13 ; \
	rpm --import https://ast.tucny.com/repo/RPM-GPG-KEY-dtucny ; \
\
#Install asterisk 13
	VERSION="13.24.0" ; \
	yum -y install --nogpgcheck asterisk-$VERSION asterisk-sip-$VERSION asterisk-iax2-$VERSION \
	asterisk-festival-$VERSION asterisk-voicemail-$VERSION asterisk-odbc-$VERSION \
	asterisk-mysql-$VERSION asterisk-moh-opsound-$VERSION asterisk-pjsip-$VERSION \
	asterisk-voicemail-plain-$VERSION asterisk-snmp-$VERSION asterisk-mp3-$VERSION \
	asterisk-sounds-core-es asterisk-sounds-core-en asterisk-moh-opsound; \
	#systemctl enable asterisk.service ; \
	yum clean all ; \
	rm -rf /var/cache/yum
\
#Create asterisk user and working directories
RUN	mkdir -p /var/lib/asterisk/{astconfig,modplus} ;  \
#link directory for external modules for asterisk
	ln -s /var/lib/asterisk/modplus /usr/lib64/asterisk/modules/modplus ; \
#/var files
	mv -f /usr/share/asterisk/* /var/lib/asterisk/ ; \
	rm -rf /usr/share/asterisk ; \
	ln -s /var/lib/asterisk /usr/share/asterisk ; \
#/etc files
	mv -f /etc/asterisk/* /var/lib/asterisk/astconfig/ ; \
	rm -rf /etc/asterisk ; \
	ln -s /var/lib/asterisk/astconfig /etc/asterisk ; \
	sed -i 's/\/usr\/share/\/var\/lib/' /etc/asterisk/asterisk.conf ; \
	sed -i 's/^;run/run/' /etc/asterisk/asterisk.conf ; \
#link to safe_asterisk
	ln -s /usr/sbin/asterisk /usr/sbin/safe_asterisk ; \
	chmod +x /usr/sbin/safe_asterisk ; \
\
#Set permissions
	chown -R asterisk. /etc/asterisk ; \
	chown -R asterisk. /var/{lib,log,spool,run}/asterisk ; \
	chown -R asterisk. /usr/{lib64,share}/asterisk
\
#Set /var as external volume
VOLUME [ "/var" ]
ENTRYPOINT ["/usr/sbin/asterisk", "-f", "-C", "/etc/asterisk/asterisk.conf"]
