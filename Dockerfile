FROM nginx:1.27-alpine

# Render 注入 PORT，nginx 模板只替换这一个变量
ENV NGINX_ENVSUBST_FILTER=PORT

COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY . /usr/share/nginx/html/

# 保活探测端点
RUN printf 'ok\n' > /usr/share/nginx/html/health.txt

EXPOSE 80
