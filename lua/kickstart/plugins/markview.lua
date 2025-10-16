return {
  enabled = false,
  'OXY2DEV/markview.nvim',
  lazy = false,
  -- SOME HYBRID MODE SETUP
  opts = {
    --   modes = { 'n', 'i', 'no', 'c' },
    hybrid_modes = { 'n', 'i' },
    --   callbacks = {
    --     on_enable = function(_, win)
    --       vim.wo[win].conceallevel = 2
    --       vim.wo[win].concealcursor = 'nc'
    --     end,
    --   },
  },
}
