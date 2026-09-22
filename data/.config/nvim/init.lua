local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "altercation/vim-colors-solarized",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        matcher = { fuzzy = false },
        win = {
          input = {
            keys = {
              ["<leader>c"] = { "close", mode = { "n", "i" } },
            },
          },
          list = {
            keys = {
              ["<leader>c"] = { "close", mode = { "n", "x" } },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<cr>", desc = "Toggle outline" },
    },
    opts = {
      outline_window = {
        position = "right",
        width = 25,
        focus_on_open = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ["H"] = "navigate_up",
            ["L"] = "set_root",
            ["h"] = "close_node",
            ["l"] = "open",
            ["e"] = "open",
            ["."] = "toggle_hidden",
            ["a"] = "add",
            ["A"] = "add_directory",
            ["r"] = "rename",
            ["d"] = "delete",
            ["c"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "python", "markdown", "markdown_inline" },
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
      vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })
    end,
  },
  {
    "m-demare/hlargs.nvim",
    opts = {},
  },
  {
    "t9md/vim-quickhl",
    lazy = false,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
          return 20
        end,
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        persist_size = true,
        direction = "horizontal",
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", dir = "git_dir", direction = "float", hidden = true })

      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
      vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
      vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Toggle vertical terminal" })
      vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Toggle horizontal terminal" })
      vim.keymap.set("n", "<leader>tg", function()
        lazygit:toggle()
      end, { desc = "Toggle lazygit" })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    opts = {},
  },
}, {
  change_detection = { notify = false },
  checker = { enabled = true },
  install = { colorscheme = { "solarized", "habamax" } },
  lockfile = vim.fn.stdpath("state") .. "/nvim/lazy-lock.json",
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.api.nvim_set_hl(0, "NeoTreeFloatNormal", { bg = "#073642", fg = "#eee8d5" })
vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { bg = "#073642", fg = "#cb4b16" })
vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { bg = "#cb4b16", fg = "#fdf6e3", bold = true })
vim.api.nvim_set_hl(0, "NeoTreeMessage", { fg = "#b58900", bold = true })

vim.keymap.set("c", "<CR>", function()
  if vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == "e." then
    vim.schedule(function()
      vim.cmd("Neotree toggle")
    end)
    return "<C-c>"
  end
  return "<CR>"
end, { expr = true, desc = "Open Neo-tree with :e." })

vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.keymap.set("i", "{} ", "{}<Left>", { noremap = true, desc = "Insert empty braces" })
vim.keymap.set("i", "[] ", "[]<Left>", { noremap = true, desc = "Insert empty brackets" })
vim.keymap.set("i", "() ", "()<Left>", { noremap = true, desc = "Insert empty parentheses" })
vim.keymap.set("i", "\"\" ", "\"\"<Left>", { noremap = true, desc = "Insert empty double quotes" })
vim.keymap.set("i", "'' ", "''<Left>", { noremap = true, desc = "Insert empty single quotes" })
vim.keymap.set("i", "`` ", "``<Left>", { noremap = true, desc = "Insert empty backticks" })
vim.keymap.set("i", "<> ", "<><Left>", { noremap = true, desc = "Insert empty angle brackets" })

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
})

if vim.fn.executable("clangd") == 1 then
  vim.lsp.enable("clangd")
end

vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
})

if vim.fn.executable("pyright-langserver") == 1 then
  vim.lsp.enable("pyright")
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

vim.keymap.set("n", "<leader>r", function()
  Snacks.picker.recent()
end, { desc = "Recent files" })

-- バッファ一覧
vim.keymap.set("n", "<leader>b", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

-- 通知
vim.keymap.set("n", "<leader>n", function()
  Snacks.notifier.show_history()
end, { desc = "Notification history" })

vim.keymap.set("n", "<leader>N", function()
  Snacks.notifier.hide()
end, { desc = "Clear notifications" })

vim.keymap.set("n", "<leader>c", function()
  for _, picker in ipairs(Snacks.picker.get()) do
    Snacks.picker.actions.close(picker)
  end
end, { desc = "Close picker" })

-- スクロール
vim.keymap.set("n", "<C-d>", function()
  require("snacks").scroll(0.5)
end, { desc = "Smooth scroll down" })

vim.keymap.set("n", "<C-u>", function()
  require("snacks").scroll(-0.5)
end, { desc = "Smooth scroll up" })

vim.keymap.set("n", "<C-j>", function()
  require("snacks").scroll(1)
end, { desc = "Smooth scroll down 1 line" })

vim.keymap.set("n", "<C-k>", function()
  require("snacks").scroll(-1)
end, { desc = "Smooth scroll up 1 line" })

-- ファイル検索
vim.keymap.set("n", "<leader>f", function()
  Snacks.picker.files()
end, { desc = "Find files" })

-- 検索
vim.keymap.set("n", "<leader>g", function()
  Snacks.picker.grep()
end, { desc = "Grep" })

vim.keymap.set({ "n", "x" }, "<leader>m", "<Plug>(quickhl-manual-this)")
vim.keymap.set({ "n", "x" }, "<leader>M", "<Plug>(quickhl-manual-reset)")
vim.keymap.set("n", "<leader>j", "<Plug>(quickhl-cword-toggle)")

-- neo-tree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>E", "<cmd>Neotree reveal<cr>", { desc = "Reveal current file in tree" })

vim.keymap.set("n", "<leader>a", function()
  Snacks.picker.treesitter({
    filter = {
      default = {
        "Class",
        "Enum",
        "Field",
        "Function",
        "Method",
        "Module",
        "Namespace",
        "Parameter",
        "Struct",
        "Trait",
        "Variable",
      },
    },
  })
end, { desc = "Browse symbols" })

-- クリップボード操作
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "Yank line to clipboard" })
vim.keymap.set("x", "<leader>y", '"+y', { desc = "Yank selection to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste after cursor" })
vim.keymap.set("n", "<leader>pp", '"+P', { desc = "Paste before cursor" })
