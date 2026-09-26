# README

Linux環境の構築を目的とする

Dockerを利用できる環境であれば簡単に構築できる。<br>
Docker を使用しない場合でも、Linux では通常のパッケージ管理を用いて環境を構築して利用できる。<br>
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

| プラグイン                       | 説明                                                                     |
| -------------------------------- | ------------------------------------------------------------------------ |
| folke/lazy.nvim                  | プラグインマネージャー。依存関係管理と遅延読み込みを行う。               |
| folke/snacks.nvim                | ピッカー、通知、入力支援などをまとめて提供するユーティリティ群。         |
| altercation/vim-colors-solarized | Solarized カラースキーム。ダークテーマを適用する。                       |
| andyg/leap.nvim                  | 高速なカーソル移動。`s` で単語や位置にジャンプする（Codeberg 経由）。    |
| hedyhli/outline.nvim             | シンボル一覧をアウトラインとして表示し、関数やクラスの見通しをよくする。 |
| folke/trouble.nvim               | 診断ビューを強化                                                         |
| tpope/vim-fugitive               | Git 操作を補助する古典的なプラグイン                                     |
| sindrets/diffview.nvim           | git の差分表示と履歴をわかりやすくするビュープラグイン                   |
| saghen/blink.cmp                 | 補完エンジン（LSP / path / snippets / buffer）                           |
| nvim-neo-tree/neo-tree.nvim      | ファイルツリー表示。プロジェクト内の移動や管理に利用する。               |
| nvim-lua/plenary.nvim            | 多くのプラグインが依存するユーティリティライブラリ                       |
| MunifTanjim/nui.nvim             | UI コンポーネントライブラリ（neo-tree などが利用）                       |
| nvim-tree/nvim-web-devicons      | ファイルアイコン表示用のアイコンセット                                   |
| nvim-treesitter/nvim-treesitter  | 構文解析とハイライト。C/C++/Python/Markdown などの構文強調を提供する。   |
| m-demare/hlargs.nvim             | 関数や引数のハイライトを強化する。                                       |
| stevearc/conform.nvim            | フォーマッタラッパー（stylua などを利用）                                |
| t9md/vim-quickhl                 | ハイライト強調の補助。検索や参照位置の可視化に使う。                     |
| nvim-lualine/lualine.nvim        | ステータスライン表示。現在のモードやファイル情報を表示する。             |
| kylechui/nvim-surround           | 選択範囲を括弧やタグで囲む補助機能を提供する。                           |
| windwp/nvim-autopairs            | 括弧の自動補完                                                           |

### プラグイン候補

| プラグイン               | 説明                                                                 | 優先度 |
| ------------------------ | -------------------------------------------------------------------- | ------ |
| stevearc/overseer.nvim   | タスク実行管理。ビルドやテスト、コマンドの実行結果を一覧で管理する。 | 低     |
| stevearc/aerial.nvim     | アウトライン（別実装の検討）                                         | 低     |
| nvim-lsp-file-operations | ファイル操作のLSP連携                                                | 高     |
| numToStr/Comment.nvim    | コメント操作                                                         | 高     |

## キーバインド

| No. | キーバインド                                                                       | 対象プラグイン           | 処理内容                                                       |
| --- | ---------------------------------------------------------------------------------- | ------------------------ | -------------------------------------------------------------- |
| 1   | `s`                                                                                | leap.nvim                | 高速なジャンプ（ノーマル/可視/オペラトールモード）             |
| 2   | `S`                                                                                | leap.nvim                | ウィンドウ内からのジャンプ                                     |
| 3   | `<leader>uo`                                                                       | outline.nvim             | アウトラインの表示切替                                         |
| 4   | `<leader>xx`, `<leader>xw`, `<leader>xd`, `<leader>xq`, `<leader>xl`, `gR`         | trouble.nvim             | 診断・クイックフィックス・ロケーションリスト・参照の表示切替   |
| 5   | `<leader>gs`, `<leader>gb`, `<leader>gl`                                           | vim-fugitive             | Git ステータス、Blame、ログ表示                                |
| 6   | `<leader>gd`, `<leader>gD`, `<leader>gh`, `<leader>gH`                             | diffview.nvim            | 差分表示、履歴表示                                             |
| 7   | `<leader>=`                                                                        | conform.nvim             | バッファまたは選択範囲の整形                                   |
| 8   | `gd`, `gD`, `gr`, `K`, `<leader>lr`, `<leader>la`, `<leader>lf`                    | nvim LSP                 | 定義・参照・ホバー・リネーム・コードアクション・整形           |
| 9   | `<leader>uf`, `<leader>ug`, `<leader>ub`, `<leader>ur`, `<leader>un`, `<leader>uN` | snacks.nvim              | ファイル検索、Grep、バッファ一覧、最近開いたファイル、通知履歴 |
| 10  | `<leader>ue`, `<leader>uE`                                                         | neo-tree.nvim            | ファイルツリーの表示切替と現在ファイルの展開                   |
| 11  | `<leader>ua`                                                                       | snacks.nvim + Treesitter | シンボル一覧の検索とジャンプ                                   |
| 12  | `<C-d>`, `<C-u>`, `<C-j>`, `<C-k>`                                                 | snacks.nvim              | スムーズスクロール                                             |
| 13  | `<leader>m`, `<leader>M`, `<leader>j`                                              | vim-quickhl              | ハイライトの強調・リセット・単語ハイライト                     |
| 14  | `<leader>tt`                                                                       | neo-tree/terminal        | ターミナルの開閉                                               |
| 15  | `<Esc><Esc>`                                                                       | terminal mode            | ターミナルからの抜け出し                                       |
| 16  | `<C-q>`                                                                            | terminal互換             | ブロック選択用の Ctrl-v 代替                                   |
| 17  | `<leader>yy`, `<leader>y`, `<leader>p`, `<leader>pp`                               | clipboad系               | 行/選択範囲のコピーと貼り付け                                  |
| 18  | `<leader>cp`, `<leader>cf`, `<leader>cc`                                           | 自前のコマンド           | ファイルパス、ファイル名、ディレクトリのコピーと移動           |
| 19  | `{} `, `[] `, `() `, `"" `, `'' `, ```` ``, `<> `                                  | 自前の挿入補助           | 空の括弧や引用符を挿入してカーソルを中央に置く                 |
| 20  | `:<CR>` の特別処理 (`:e.`)                                                         | 自前のコマンド           | `:e.` で Neo-tree を開く                                       |

## TODO

- trouble.nvim のキーバインドが有効か？ xx, xd, xw, xl など意味があるか 要確認。
- バッファのパスコピーのキーバインドを検討
