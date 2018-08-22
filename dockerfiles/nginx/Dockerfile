FROM nginx:latest

RUN mkdir /etc/certs \
    && chown root:root /etc/certs \
    && chmod 555 /etc/certs

CMD ["/bin/bash", "-c", "envsubst '${NGINX_HOST}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"]
