FROM debian:latest

LABEL maintainer="John Day" \
      version=0.2 \
      description="Openconnect server with libpam-ldap for openldap" 

VOLUME /config

RUN apt-get update && apt-get -y install ocserv libnss-ldap iptables procps rsync sipcalc ca-certificates
RUN rm /etc/pam_ldap.conf && touch /config/pam_ldap.conf && ln -s /config/pam_ldap.conf /etc/pam_ldap.conf

ADD ocserv /etc/default/ocserv
ADD pam_ldap /etc/default/pam_ldap

WORKDIR /config

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 443/tcp
EXPOSE 443/udp
CMD ["ocserv", "-c", "/config/ocserv.conf", "-f"]
