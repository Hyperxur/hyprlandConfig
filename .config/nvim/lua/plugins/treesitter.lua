require'nvim-treesitter.configs'.setup {
  ensure_installed = { "vim", "c", "lua" },

  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
