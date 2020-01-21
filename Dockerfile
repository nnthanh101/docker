FROM node:lts-alpine as builder
LABEL maintainer="nnthanh101@gmail.com"

WORKDIR /webapp

COPY . /webapp
ENV PATH /app/node_modules/.bin:$PATH
RUN yarn
RUN yarn build

FROM nginx:alpine
# copy the build folder from react to the root of nginx (www)
COPY --from=builder /webapp/build /usr/share/nginx/html
# React Router: overwrite the default nginx configurations
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80

# start nginx 
CMD ["nginx", "-g", "daemon off;"]