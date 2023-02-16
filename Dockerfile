FROM rust:1.67 as builder
WORKDIR /usr/src/three-dee-files-api
COPY . .
RUN cargo install --path .

FROM debian:bullseye-slim
RUN rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/three-dee-files-api /usr/local/bin/three-dee-files-api
CMD ["three-dee-files-api"]