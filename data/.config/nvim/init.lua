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
    opts = {},
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "m-demare/hlargs.nvim",
    opts = {},
  },
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
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
  install = { colorscheme = { "habamax" } },
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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- 通知履歴
vim.keymap.set("n", "<leader>nn", function()
  Snacks.notifier.show_history()
end, { desc = "Snacks: notification history" })

vim.keymap.set("n", "<leader>no", function()
  Snacks.notifier.hide()
end, { desc = "Snacks: clear notifications" })

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

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })
-- vim.keymap.set("n", "<leader>ff", function()
--   Snacks.picker.files()
-- end, { desc = "Find files" })
-- vim.keymap.set("n", "<leader>fg", function()
--   Snacks.picker.grep()
-- end, { desc = "Grep files" })
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>", { desc = "Toggle symbols" })
vim.keymap.set("n", "<leader>oo", "<cmd>OverseerToggle<cr>", { desc = "Toggle tasks" })