FROM debian:bookworm-slim

RUN set -eux; \
    apt-get update && apt-get install --no-install-recommends -y curl gnupg ca-certificates; \
    curl --fail https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor > /usr/share/keyrings/winehq.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/winehq.gpg] https://dl.winehq.org/wine-builds/debian/ bookworm main" > /etc/apt/sources.list.d/winehq.list; \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install --no-install-recommends -y libwebkit2gtk-4.0-dev \
        build-essential \
        curl \
        wget \
        libssl-dev \
        libgtk-3-dev \
        libayatana-appindicator3-dev \
        librsvg2-dev \
        nsis \
        nodejs \
        npm \
        clang \
        winehq-staging \
        cmake \
        ninja-build; \
    apt-get remove -y --auto-remove; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup target add x86_64-pc-windows-msvc aarch64-pc-windows-msvc && \
    rustup component add llvm-tools-preview
RUN cargo install cargo-xwin
# RUN xwin --accept-license splat --output /xwin

RUN npm install -g corepack && corepack enable
RUN cargo install tauri-cli --branch fix/xwin --git https://github.com/chippers/tauri
