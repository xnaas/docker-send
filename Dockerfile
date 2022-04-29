###########
# builder #
FROM node:16-alpine as builder
ARG SEND_VERSION

RUN apk --no-cache add git

WORKDIR /app
RUN git clone --depth 1 --branch $SEND_VERSION https://github.com/timvisee/send .
RUN PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true npm ci
RUN npm run build


#######
# app #
FROM node:16-alpine

WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/app app
COPY --from=builder /app/common common
COPY --from=builder /app/public/locales public/locales
COPY --from=builder /app/server server
COPY --from=builder /app/dist dist

RUN npm ci --production && npm cache clean --force
RUN mkdir -p /app/.config/configstore
RUN ln -s dist/version.json version.json

EXPOSE 1443
VOLUME /uploads

CMD ["node", "server/bin/prod.js"]
