FROM rust as builder
WORKDIR /src
COPY . .
# This works with the dummy project generated by `cargo new app --bin`
RUN cargo build --release --bin bakeoff-rust

FROM debian:bullseye-slim as runtime
RUN apt-get update  && apt-get install libpq5 -y
RUN rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY --from=builder /src/target/release/bakeoff-rust /usr/local/bin
ENTRYPOINT ["/usr/local/bin/bakeoff-rust"]
