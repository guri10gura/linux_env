# README
Linux環境の構築を目的とする

Dockerを利用できる環境であれば構築できる。
また、Docker を使用しない場合でも、Linux では通常のパッケージ管理を用いて環境を構築して利用できる。
Dockerを使用しない場合、Windowsでは nvimの設定のみサポートする。

## Dockerを利用する場合
### 準備
* Dockerのインストール
[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

### 現行ユーザーをdockerグループに所属させる
本手順で Docker を sudo なしで使用できるようになる
```shell
# dockerグループがなければ作る
sudo groupadd docker

# 現行ユーザをdockerグループに所属させる
sudo gpasswd -a $USER docker

# dockerデーモンを再起動する
sudo systemctl restart docker

# exitして再ログインすると反映される。
exit
```

### 手順
下記のコマンドで 環境構築できる。
```shell
$ docker compose up
```
dockerコンテナを実行することで環境を利用できる
```shell
$ docker exec -it linux_env shell
```

## Dockerを利用しない場合(Linux)
### 準備
* 必要なパッケージをインストールする(Dockerfileを参照)
* nvimはv0.11.4以上が必要となる

### 手順
下記のコマンドで 環境を構築する
```shell
$ ./script/setup_linux.sh
```


## Dockerを利用しない場合(Windows)
### 準備
* nvim 本体をインストール
```
> winget install Neovim.Neovim
```

* ripgrep をインストール
```cmd
> winget install BurntSushi.ripgrep.MSVC
```

### 手順
下記のコマンドで nvim設定を適用する
```shell
$ ./script/setup_windows.sh
```

## Dockerfile
### インストールパッケージ:
* build-essential
* cmake
* ripgrep
* git
* Neovim 0.11.4
* python3
* tmux

### その他の設定
Ubuntu24.04
ユーザー名：user
パスワード：user
コンテナの~/host に ホストの ~ をバインド
コンテナから ~/host 配下に書き込み可能とする
プロジェクトの `data` 配下にあるユーザー設定を個別にバインド

### ユーザー設定の構成

```text
data/
├── .bashrc
├── .gitconfig
├── .tmux.conf
├── .cache/nvim/
├── .config/nvim/
└── .local/
	├── share/nvim/
	└── state/nvim/
```

`/home/user` 全体はバインドせず、Neovim 設定のみ読み取り専用でマウントする。



## Neovim設定
### プラグイン

* snacks.nvim
* lazy.nvim
* blink.cmp
* nvim-neo-tree/neo-tree.nvim
* leap.nvim
* m-demare/hlargs.nvim
* stevearc/aerial.nvim
* stevearc/overseer.nvim
* nvim-lualine/lualine.nvim
