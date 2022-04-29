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
COPY --from=builder /app/dist .

RUN npm ci --production && npm cache clean --force
RUN mkdir -p /app/.config/configstore

ENV PORT=1443
EXPOSE $PORT

CMD ["node", "server/bin/prod.js"]
