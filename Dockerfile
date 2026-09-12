FROM ubuntu:24.04

ARG UID=1000
ARG GID=1000

# パッケージ更新とインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    neovim \
    python3 \
    tmux \
    sudo \
    && apt-get clean

# user:user を作成
RUN userdel -r ubuntu || true \
    && groupdel ubuntu 2>/dev/null || true \
    && groupadd --gid "${GID}" user \
    && useradd --uid "${UID}" --gid "${GID}" -m -s /bin/bash user \
    && echo "user:user" | chpasswd \
    && usermod -aG sudo user

# 作業ディレクトリ
WORKDIR /home/user

# user に切り替え
USER user
