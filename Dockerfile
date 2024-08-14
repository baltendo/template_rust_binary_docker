# https://github.com/clux/muslrust/blob/main/Dockerfile
FROM clux/muslrust:1.80.1-stable as builder

# Install target platform (Cross-Compilation) --> Needed for Alpine
RUN rustup target add x86_64-unknown-linux-musl

# Create workdir
RUN mkdir -p /usr/src/workdir/

# Copy code
COPY Cargo.toml Cargo.lock /usr/src/workdir/
COPY src /usr/src/workdir/src

# Switch to the workdir
WORKDIR /usr/src/workdir

# Build
RUN cargo build --target x86_64-unknown-linux-musl --release

# ---

FROM clux/muslrust:1.80.1-stable AS runtime

COPY --from=builder --chown=nonroot:nonroot /usr/src/workdir/target/x86_64-unknown-linux-musl/release /usr/local/bin

CMD ["/usr/local/bin/main"]
