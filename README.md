# docker-send

## source

[Source repository.](https://github.com/timvisee/send)

## example

Note: This example is incomplete and does not include
needed environment variable information. Refer to source
repo for more info on env vars.

```
  send:
    image: ghcr.io/xnaas/send:latest
    container_name: send
    restart: unless-stopped
    depends_on:
      send-redis:
        condition: service_healthy
    ports:
      - "1443:1443"
    networks:
      - send
    volumes:
      - ./send/uploads:/uploads
  send-redis:
    image: redis:alpine
    container_name: send-redis
    restart: unless-stopped
    networks:
      - send
    volumes:
      - ./send/redis:/data
    healthcheck:
      test: [ "CMD", "redis-cli", "ping" ]
      interval: 10s
      timeout: 45s
      retries: 10
```
