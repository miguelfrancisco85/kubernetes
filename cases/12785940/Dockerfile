FROM nginx

RUN apt-get update && \
    apt-get install curl git wget siege -y

RUN ln -s /var/log/nginx /etc/nginx/logs

ADD configs/nginx.conf /etc/nginx/nginx.conf
ADD certs/nginx.crt /etc/nginx/ssl/nginx.crt
ADD certs/nginx.key /etc/nginx/ssl/nginx.key

RUN mkdir -p /var/www/html

ADD index.html /var/www/html/index.html
RUN touch /var/www/html/healthz

RUN chmod 755 /var/www/html

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]

