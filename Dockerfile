FROM debian:jessie

ENV NGINX_VERSION=1.11.1-1~jessie \
    TERM=xterm-256color

ADD packages/nginx_${NGINX_VERSION}_amd64.deb /tmp/nginx.deb

RUN apt-get update && \
    apt-get install -y nano libldap2-dev telnet ca-certificates && \
    dpkg -i /tmp/nginx.deb && \
    rm -rf /var/lib/apt/lists/* && \
	mv /etc/nginx /etc/nginx_dist && \
	ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log


EXPOSE 80 443


COPY webserver-entrypoint.sh /

VOLUME \
	/data \
	/etc/nginx \
	/usr/share/nginx/html \
	/var/www \
	/var/log/nginx \
	/var/cache/nginx \
	/var/cache/pagespeed
	
ENTRYPOINT ["/webserver-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
