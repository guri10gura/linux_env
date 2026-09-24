local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
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
              ["<leader>uc"] = { "close", mode = { "n", "i" } },
            },
          },
          list = {
            keys = {
              ["<leader>uc"] = { "close", mode = { "n", "x" } },
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
      { "<leader>uo", "<cmd>Outline<cr>", desc = "Toggle outline" },
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
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle", "TroubleClose", "TroubleRefresh" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: workspace diagnostics" },
      { "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: workspace diagnostics (alias)" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: document diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: quickfix" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: loclist" },
      { "gR", "<cmd>Trouble lsp_references toggle<cr>", desc = "Trouble: references" },
    },
    opts = {
      auto_open = false,
      auto_close = false,
      use_diagnostic_signs = true,
      focus = true,
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gblame" },
    keys = {
      { "<leader>gs", "<cmd>Git status<cr>", desc = "Git status (read-only)" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      {
        "<leader>gl",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local term = Terminal:new({
            cmd = "git --no-pager log --graph --decorate --all --date=short --format='%C(yellow)%h%Creset %s %C(green)(%cr)%Creset'",
            direction = "float",
            hidden = true,
            close_on_exit = false,
          })
          term:toggle()
        end,
        desc = "Git log graph (terminal)",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
      "DiffviewLog",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: project history" },
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = {
        preset = "default",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
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
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter is not available yet; skipping Treesitter setup.", vim.log.levels.WARN)
        return
      end

      configs.setup({
        ensure_installed = { "c", "cpp", "python", "markdown", "markdown_inline" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
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
    config = function()
      require("hlargs").setup({
        hl_priority = 150,
        paint_arg_declarations = true,
        paint_arg_usages = true,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>=",
        function()
          local mode = vim.fn.mode()
          if mode == "v" or mode == "V" or mode == "\x16" then
            if vim.bo.filetype == "markdown" then
              require("conform").format({ async = true, lsp_fallback = true })
              return
            end

            local range = {
              start = { vim.fn.line("'<"), 0 },
              ["end"] = { vim.fn.line("'>"), vim.fn.col("'>") - 1 },
            }
            require("conform").format({ async = true, lsp_fallback = true, range = range })
            return
          end

          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "x" },
        desc = "Format selection or buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "black" },
        cpp = { "clang_format" },
        c = { "clang_format" },
        markdown = { "prettier" },
      },
      format_on_save = false,
    },
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
      Terminal:new({ cmd = "lazygit", dir = "git_dir", direction = "float", hidden = true })

      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
      vim.keymap.set("n", "<leader>tv", function()
        local Terminal = require("toggleterm.terminal").Terminal
        local term = Terminal:new({
          direction = "vertical",
          dir = vim.fn.getcwd(),
          hidden = false,
        })
        term:toggle()
      end, { desc = "Toggle vertical terminal in current working directory" })
      vim.keymap.set("n", "<leader>th", function()
        local Terminal = require("toggleterm.terminal").Terminal
        local term = Terminal:new({
          direction = "horizontal",
          dir = vim.fn.getcwd(),
          hidden = false,
        })
        term:toggle()
      end, { desc = "Toggle horizontal terminal in current working directory" })
      vim.keymap.set("n", "<leader>tg", function()
        local Terminal = require("toggleterm.terminal").Terminal
        local status = Terminal:new({
          cmd = "git --no-pager status --short --branch",
          direction = "float",
          hidden = true,
        })
        status:toggle()
      end, { desc = "Git status (read-only)" })
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
  change_detection = { enabled = false, notify = false },
  checker = { enabled = false },
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

vim.api.nvim_set_hl(0, "@text.title", { fg = "#2aa198", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#2aa198", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#268bd2", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#6c71c4", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#859900", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#d33682", bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#cb4b16", bold = true })
vim.api.nvim_set_hl(0, "@markup.link.markdown", { fg = "#268bd2", underline = true })
vim.api.nvim_set_hl(0, "@markup.raw.markdown", { fg = "#859900", bold = true })
vim.api.nvim_set_hl(0, "@markup.list.markdown", { fg = "#93a1a1", bold = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.md", "*.markdown" },
  callback = function(args)
    vim.bo[args.buf].filetype = "markdown"
    pcall(vim.treesitter.start, args.buf, "markdown")
  end,
})

local blocked_git_commands = {
  "commit", "push", "pull", "fetch", "merge", "rebase", "reset", "checkout", "switch", 
  "restore", "cherry-pick", "tag", "branch", "remote", "stash", "submodule", "clone",
  "init", "add", "rm", "mv",
}

local function git_guard(args)
  if not args or #args == 0 then
    vim.cmd("Git status")
    return
  end

  local first = args[1]:lower()
  if vim.tbl_contains(blocked_git_commands, first) then
    vim.notify("Blocked: git " .. first .. " is disabled for safety.", vim.log.levels.WARN)
    return
  end

  vim.cmd("Git " .. table.concat(args, " "))
end

vim.api.nvim_create_user_command("Git", function(opts)
  git_guard(opts.fargs)
end, { nargs = "*" })

vim.api.nvim_create_user_command("G", function(opts)
  git_guard(opts.fargs)
end, { nargs = "*" })

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
    "--header-insertion=never",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.c", "*.h", "*.cc", "*.cpp", "*.hpp", "*.cxx", "*.hxx" },
  callback = function(args)
    if vim.fn.executable("clangd") ~= 1 then
      return
    end

    if vim.lsp.get_clients({ bufnr = args.buf, name = "clangd" })[1] then
      return
    end

    local file = vim.api.nvim_buf_get_name(args.buf)
    local root_dir = vim.fs.root(file, { ".git", "compile_commands.json", "compile_flags.txt" })
    if not root_dir then
      root_dir = vim.fn.getcwd()
    end

    vim.lsp.start({
      name = "clangd",
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=never",
      },
      root_dir = root_dir,
      filetypes = { "c", "cpp", "objc", "objcpp" },
      capabilities = vim.lsp.protocol.make_client_capabilities(),
    }, { bufnr = args.buf })
  end,
})

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

vim.keymap.set("n", "<leader>uf", function()
  Snacks.picker.files()
end, { desc = "Snacks: files" })

vim.keymap.set("n", "<leader>ug", function()
  Snacks.picker.grep()
end, { desc = "Snacks: grep" })

vim.keymap.set("n", "<leader>ub", function()
  Snacks.picker.buffers()
end, { desc = "Snacks: buffers" })

vim.keymap.set("n", "<leader>ur", function()
  Snacks.picker.recent()
end, { desc = "Snacks: recent files" })

vim.keymap.set("n", "<leader>un", function()
  Snacks.notifier.show_history()
end, { desc = "Snacks: notification history" })

vim.keymap.set("n", "<leader>uN", function()
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

vim.keymap.set({ "n", "x" }, "<leader>m", "<Plug>(quickhl-manual-this)")
vim.keymap.set({ "n", "x" }, "<leader>M", "<Plug>(quickhl-manual-reset)")
vim.keymap.set("n", "<leader>j", "<Plug>(quickhl-cword-toggle)")

-- neo-tree
vim.keymap.set("n", "<leader>ue", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>uE", "<cmd>Neotree reveal<cr>", { desc = "Reveal current file in tree" })

vim.keymap.set("n", "<leader>ua", function()
  Snacks.picker.treesitter({
    filter = {
      default = {
        "Class", "Enum", "Field", "Function", "Method", "Module", 
        "Namespace", "Parameter", "Struct", "Trait", "Variable",
      },
    },
  })
end, { desc = "Browse symbols" })

-- クリップボード操作
-- Blockwise visual selection: terminal paste often captures Ctrl-v first.
-- Use Ctrl-q as the Vim block selection key instead.
vim.keymap.set({ "n", "v", "o" }, "<C-q>", "<C-v>", { noremap = true, desc = "Blockwise visual selection" })

vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "Yank line to clipboard" })
vim.keymap.set("x", "<leader>y", '"+y', { desc = "Yank selection to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste after cursor" })
vim.keymap.set("n", "<leader>pp", '"+P', { desc = "Paste before cursor" })

vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied full path: " .. path, vim.log.levels.INFO)
end, { desc = "Copy full path to clipboard" })
vim.keymap.set("n", "<leader>cf", function()
  local file = vim.fn.expand("%:t")
  vim.fn.setreg("+", file)
  vim.notify("Copied file name: " .. file, vim.log.levels.INFO)
end, { desc = "Copy file name to clipboard" })
vim.keymap.set("n", "<leader>cc", function()
  local path = vim.fn.expand("%:p:h")
  if path == "" or path == "." then
    return
  end

  vim.cmd("cd " .. vim.fn.fnameescape(path))
  vim.notify("Changed directory to: " .. path, vim.log.levels.INFO)
end, { desc = "Change directory to current file directory" })

