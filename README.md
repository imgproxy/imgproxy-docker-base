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
  darthsim/imgproxy-base:latest
```

...and build your imgproxy as usual:

```shell
go build
```

### For production

If you don't care about the size, you can just build your Docker image on top of this one:

```dockerfile
FROM darthsim/imgproxy-base:latest

COPY . .
RUN go build -v -o /usr/local/bin/imgproxy

CMD ["imgproxy"]

EXPOSE 8080
```

But you probably want to use multistage build to minimize the final image, and it's a bit tricky. You need to take care of the following:

1. Copy built dependencies from `/usr/local/lib`.
2. Install ca-certificates, libsm6, liblzma5, and libzstd1 from the Debian repo.
3. Set proper libraries paths.

Here is the working example:

```dockerfile
FROM darthsim/imgproxy-base:latest

COPY . .
RUN go build -v -o /usr/local/bin/imgproxy

# ==================================================================================================
# Final image

FROM debian:buster-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    libsm6 \
    liblzma5 \
    libzstd1 \
  && rm -rf /var/lib/apt/lists/*

COPY --from=0 /usr/local/bin/imgproxy /usr/local/bin/
COPY --from=0 /usr/local/lib /usr/local/lib

ENV LD_LIBRARY_PATH /usr/local/lib

CMD ["imgproxy"]

EXPOSE 8080
```

## Author

Sergey "[DarthSim](https://github.com/DarthSim)" Alexandrovich

## License

imgproxy-base is licensed under the MIT license.

See LICENSE for the full license text.
