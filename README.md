# README

## Docker のインストール
[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

## Docker をsudoなしで使用
```shell
# dockerグループがなければ作る
sudo groupadd docker

# 現行ユーザをdockerグループに所属させる
sudo gpasswd -a $USER docker

# dockerデーモンを再起動する (CentOS7の場合)
sudo systemctl restart docker

# exitして再ログインすると反映される。
exit
```




## Dockerfile
### インストールパッケージ:
build-essential
cmake
git
Neovim 0.11.4
python3
tmux

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

snacks.nvim
lazy.nvim
blink.cmp
nvim-neo-tree/neo-tree.nvim
leap.nvim
m-demare/hlargs.nvim
stevearc/aerial.nvim
stevearc/overseer.nvim
nvim-lualine/lualine.nvim


