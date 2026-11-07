FROM alpine:3.21
ARG TARGETARCH

RUN apk add --no-cache ca-certificates tzdata wget unzip \
 && case "$TARGETARCH" in \
      amd64) XRAY_ASSET="Xray-linux-64.zip" ;; \
      arm64) XRAY_ASSET="Xray-linux-arm64-v8a.zip" ;; \
      *) echo "Unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac \
 && wget -qO /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/v25.3.6/${XRAY_ASSET}" \
 && unzip /tmp/xray.zip xray -d /usr/local/bin \
 && chmod 755 /usr/local/bin/xray \
 && rm -f /tmp/xray.zip

COPY config.json /etc/xray/config.json
EXPOSE 3000
CMD ["/bin/sh", "-c", "test -n \"$UUID\" || exit 1; sed -i \"s/REPLACE_WITH_UUID/$UUID/g\" /etc/xray/config.json; exec /usr/local/bin/xray run -c /etc/xray/config.json"]
