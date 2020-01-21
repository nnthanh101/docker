FROM node:lts-alpine as builder
LABEL maintainer="nnthanh101@gmail.com"

WORKDIR /webapp

COPY package.json /webapp/package.json
RUN yarn install
COPY . /webapp/
RUN yarn build

FROM nginx:alpine
# copy the build folder from react to the root of nginx (www)

ENV DEBUG=off                 \
    APP_VERSION="v1.0.0"      \
    APP_DIR=/webapp           \
    CLIENT_BODY_TIMEOUT=10    \
    CLIENT_HEADER_TIMEOUT=10  \
    CLIENT_MAX_BODY_SIZE=1024 \
    WHITE_LIST_IP=(172.17.0.1)|(192.168.0.25) \
    WHITE_LIST=off
COPY --from=builder /webapp/build /usr/share/nginx/html
# React Router: overwrite the default nginx configurations
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d/app.conf.template
COPY nginx/start-nginx.sh /usr/sbin/start
RUN chmod u+x /usr/sbin/start

EXPOSE 80

# start nginx 
CMD ["start"]
