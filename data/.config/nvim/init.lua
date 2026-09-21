local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

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
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
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
            ["H"] = "toggle_hidden",
            ["a"] = "add",
            ["A"] = "add_directory",
            ["r"] = "rename",
            ["d"] = "delete",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
  },
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
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
    "stevearc/overseer.nvim",
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

vim.keymap.set("n", "<leader>t", "<cmd>OverseerToggle<cr>", { desc = "Toggle tasks" })