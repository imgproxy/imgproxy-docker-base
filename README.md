# imgproxy Docker base

## What is this?

Base Docker image with the latest imgproxy dependencies. Ideal for imgproxy development and building its Docker images.

## How to use this?

### For development

Run this image with your development directory mounted:

```shell
docker run --rm -it \
  -p 8080:8080 \
  -v $(pwd):/app \
  --name imgproxy_dev \
  ghcr.io/imgproxy/imgproxy-base:latest
```

...and build your imgproxy as usual:

```shell
go build
```

### For production

If you don't care about the size, you can just build your Docker image on top of this one:

```dockerfile
FROM ghcr.io/imgproxy/imgproxy-base:latest

COPY . .
# We use bash here to load dynamically generated build environment from /root/.basrc
RUN ["bash", "-c", "go build -v -o /opt/imgproxy/bin/imgproxy"]
RUN ln -s /opt/imgproxy/bin/imgproxy /usr/local/bin/imgproxy

ENV VIPS_WARNING=0
ENV MALLOC_ARENA_MAX=2

RUN groupadd -r imgproxy && useradd -r -u 999 -g imgproxy imgproxy
USER 999

CMD ["imgproxy"]

EXPOSE 8080
```

But you probably want to use multistage build to minimize the final image, and it's a bit tricky. You need to take care of the following:

1. Copy built dependencies from `/opt/imgproxy`.
2. Install required system dependencies.

Here is the working example:

```dockerfile
FROM ghcr.io/imgproxy/imgproxy-base:latest

COPY . .
RUN ["bash", "-c", "go build -v -o /opt/imgproxy/bin/imgproxy"]

# Remove unnecessary files
RUN rm -rf /opt/imgproxy/lib/pkgconfig /opt/imgproxy/lib/cmake

# ==================================================================================================
# Final image

FROM public.ecr.aws/ubuntu/ubuntu:noble

RUN apt-get update \
  && apt-get upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    libstdc++6 \
    fontconfig-config \
    fonts-dejavu-core \
    media-types \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/fonts/conf.d/10-sub-pixel-rgb.conf /etc/fonts/conf.d/11-lcdfilter-default.conf

COPY --from=build /opt/imgproxy/bin/imgproxy /opt/imgproxy/bin/
COPY --from=build /opt/imgproxy/lib /opt/imgproxy/lib
RUN ln -s /opt/imgproxy/bin/imgproxy /usr/local/bin/imgproxy

ENV VIPS_WARNING=0
ENV MALLOC_ARENA_MAX=2

RUN groupadd -r imgproxy && useradd -r -u 999 -g imgproxy imgproxy
USER 999

CMD ["imgproxy"]

EXPOSE 8080
```

## Author

Sergey "[DarthSim](https://github.com/DarthSim)" Alexandrovich

## License

imgproxy-base is licensed under the MIT license.

See LICENSE for the full license text.
