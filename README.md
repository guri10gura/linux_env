# README

Linux環境の構築を目的とする

Dockerを利用できる環境であれば構築できる。
また、Docker を使用しない場合でも、Linux では通常のパッケージ管理を用いて環境を構築して利用できる。
Dockerを使用しない場合、Windowsでは nvimの設定のみサポートする。

## Dockerを利用する場合

### 準備

- Dockerのインストール
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

- 必要なパッケージをインストールする(Dockerfileを参照)
- nvimはv0.11.4以上が必要となる

### 手順

下記のコマンドで 環境を構築する

```shell
$ ./script/setup_linux.sh
```

## Dockerを利用しない場合(Windows)

### 準備

- nvim 本体をインストール

```
> winget install Neovim.Neovim
```

- ripgrep をインストール
  <br>snapsでgrepを利用するために必要

```cmd
> winget install BurntSushi.ripgrep.MSVC
```

- clangd をインストール
  <br>outline.nvimが利用する C/C++ 向けLSP作成のため必要

```
> winget install --id LLVM.clangd --exact
```

- pyright をインストール
  <br>outline.nvimが利用する python向けLSP作成のため必要
  - Node.jsをインストール
    <br>[Node.js®をダウンロードする](https://nodejs.org/ja/download)
  - npmでpyrightをインストール

```powershell
> npm install -g pyright
```

### 手順

下記のコマンドで nvim設定を適用する

```shell
$ ./script/setup_windows.sh
```

## Dockerfile

### インストールパッケージ:

- build-essential
- clangd
- cmake
- nodejs
- npm
- ripgrep
- git
- Neovim 0.11.4
- pyright
- python3
- tmux

### その他の設定

- Ubuntu24.04
- ユーザー名：user
- パスワード：user
- コンテナの~/host に ホストの ~ をバインド
- コンテナから ~/host 配下に書き込み可能とする
- プロジェクトの `data` 配下にあるユーザー設定を個別にバインド

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

| プラグイン                       | 説明                                                                       |
| -------------------------------- | -------------------------------------------------------------------------- |
| folke/lazy.nvim                  | プラグインマネージャー。依存関係管理と遅延読み込みを行う。                 |
| folke/snacks.nvim                | ファイラ、ピッカー、通知、入力支援などをまとめて提供するユーティリティ群。 |
| altercation/vim-colors-solarized | Solarized カラースキーム。ダークテーマを適用する。                         |
| hedyhli/outline.nvim             | シンボル一覧をアウトラインとして表示し、関数やクラスの見通しをよくする。   |
| saghen/blink.cmp                 | 補完エンジン。LSP、path、snippet、buffer を組み合わせて補完を行う。        |
| nvim-neo-tree/neo-tree.nvim      | ファイルツリー表示。プロジェクト内の移動や管理に利用する。                 |
| nvim-treesitter/nvim-treesitter  | 構文解析とハイライト。C/C++/Python/Markdown などの構文強調を提供する。     |
| andyg/leap.nvim                  | 高速なカーソル移動。`s` で単語や位置にジャンプする。                       |
| m-demare/hlargs.nvim             | 関数や引数のハイライトを強化する。                                         |
| t9md/vim-quickhl                 | ハイライト強調の補助。検索や参照位置の可視化に使う。                       |
| akinsho/toggleterm.nvim          | 端末の開閉を容易にし、lazygit や複数のシェルを扱う。                       |
| nvim-lualine/lualine.nvim        | ステータスライン表示。現在のモードやファイル情報を表示する。               |
| kylechui/nvim-surround           | 選択範囲を括弧やタグで囲む補助機能を提供する。                             |
| sindrets/diffview.nvim           | git diff                                                                   |
| folke/trouble.nvim               | 診断ビューを強化                                                           |

### プラグイン候補

| プラグイン               | 説明                                                                 | 優先度 |
| ------------------------ | -------------------------------------------------------------------- | ------ |
| stevearc/overseer.nvim   | タスク実行管理。ビルドやテスト、コマンドの実行結果を一覧で管理する。 | 低     |
| stevearc/aerial.nvim     | アウトライン                                                         | 低     |
| stevearc/conform.nvim    | フォーマッタ                                                         | 高     |
| nvim-lsp-file-operations | ファイル操作のLSP連携                                                | 高     |
| numToStr/Comment.nvim    | コメント操作                                                         | 高     |
| windwp/nvim-autopairs    | 括弧の自動補完                                                       | 高     |

## TODO

- trouble.nvim のキーバインドが有効か？ xx, xd, xw, xl など意味があるか 要確認。
- バッファのパスコピーのキーバインドを検討
