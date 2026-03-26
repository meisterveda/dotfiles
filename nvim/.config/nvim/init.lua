-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 250
vim.opt.undofile = true

-- Plugins
require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, config = function() vim.cmd.colorscheme("catppuccin-mocha") end },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
    require("nvim-treesitter.configs").setup({ ensure_installed = { "typescript", "tsx", "javascript", "rust", "go", "lua", "yaml", "json", "markdown", "bash" }, highlight = { enable = true } })
  end },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>" },
  }},
  { "lewis6991/gitsigns.nvim", config = true },
  { "folke/which-key.nvim", config = true },
  { "nvim-lualine/lualine.nvim", config = function() require("lualine").setup({ options = { theme = "catppuccin" } }) end },
  { "neovim/nvim-lspconfig", config = function()
    local lsp = require("lspconfig")
    local servers = { "ts_ls", "rust_analyzer", "gopls", "lua_ls", "pyright" }
    for _, server in ipairs(servers) do lsp[server].setup({}) end
  end },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" }, config = function()
    local cmp = require("cmp")
    cmp.setup({ mapping = cmp.mapping.preset.insert({ ["<CR>"] = cmp.mapping.confirm({ select = true }), ["<C-Space>"] = cmp.mapping.complete() }), sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "buffer" }, { name = "path" } }) })
  end },
  { "windwp/nvim-autopairs", config = true },
  { "numToStr/Comment.nvim", config = true },
})

-- Keymaps
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
