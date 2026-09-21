FROM ubuntu:24.04

ARG UID=1000
ARG GID=1000
ARG NEOVIM_VERSION=0.11.4

# UID/GID is inherited from the host when passed via build args.
# If the value is empty, fall back to 1000.
ENV UID=${UID:-1000}
ENV GID=${GID:-1000}

# パッケージ更新とインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    clangd \
    cmake \
    curl \
    git \
    nodejs \
    npm \
    python3 \
    ripgrep \
    tmux \
    sudo \
    && npm install --global pyright \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux-x86_64.tar.gz" \
        | tar -xz -C /opt \
    && ln -s "/opt/nvim-linux-x86_64/bin/nvim" /usr/local/bin/nvim

# user:user を作成
RUN UID="${UID:-1000}" \
    && GID="${GID:-1000}" \
    && userdel -r ubuntu || true \
    && groupdel ubuntu 2>/dev/null || true \
    && groupadd --gid "${GID}" user \
    && useradd --uid "${UID}" --gid "${GID}" -m -s /bin/bash user \
    && echo "user:user" | chpasswd \
    && usermod -aG sudo user \
    && mkdir -p /home/user/.local/share/nvim /home/user/.local/state/nvim \
    && chown -R user:user /home/user/.local

# 作業ディレクトリ
WORKDIR /home/user

# user に切り替え
USER user

# bind mount した設定を使って bash を起動
CMD ["bash"]
