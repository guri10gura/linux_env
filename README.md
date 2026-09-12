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
nvim
python3
tmux

### その他の設定
Ubuntu24.04
ユーザー名：user
パスワード：user
コンテナの~/host に ホストの ~ をバインド
コンテナの ~ に カレントディレクトリ（本ファイルのパス）をバインド
コンテナから ~/host 配下に書き込み可能とする


