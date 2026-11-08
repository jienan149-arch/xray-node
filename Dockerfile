# syntax=docker/dockerfile:1
FROM ghcr.io/xtls/xray-core:25.3.6 AS xray
FROM alpine:3.21
COPY --from=xray /usr/bin/xray /usr/local/bin/xray
RUN apk add --no-cache ca-certificates tzdata
COPY config.json /etc/xray/config.json
EXPOSE 3000
CMD ["/bin/sh", "-c", "test -n \"$UUID\" || exit 1; sed -i \"s/REPLACE_WITH_UUID/$UUID/g\" /etc/xray/config.json; exec /usr/local/bin/xray run -c /etc/xray/config.json"]






