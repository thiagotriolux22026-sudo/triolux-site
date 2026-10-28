FROM nginx:alpine
ENV SITE_URL="" \
    CRM_URL="https://cmr-triolux-crm.nrzz4w.easypanel.host" \
    VITRINE_URL="" \
    CHAT_URL=""
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY seguranca.conf /etc/nginx/snippets/seguranca.conf
COPY 40-site-url.sh /docker-entrypoint.d/40-site-url.sh
RUN sed -i 's/\r$//' /docker-entrypoint.d/40-site-url.sh && chmod +x /docker-entrypoint.d/40-site-url.sh
COPY index.html 404.html robots.txt site.webmanifest /usr/share/nginx/html/
COPY img/ /usr/share/nginx/html/img/
EXPOSE 80
