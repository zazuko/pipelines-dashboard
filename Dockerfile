ARG NODE_VERSION=14

FROM node:${NODE_VERSION} as builder

WORKDIR /app

# Build the app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
ENV NODE_ENV=production
RUN npm run build


FROM nginx:1.19.4-alpine

ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf
ADD ./nginx/template-config.sh /docker-entrypoint.d/50-template-config.sh
RUN chmod +x /docker-entrypoint.d/50-template-config.sh

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
