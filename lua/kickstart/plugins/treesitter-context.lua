-- Further config stuff can be looked up at https://www.josean.com/posts/nvim-treesitter-and-textobjects
return {
  enabled = false,
  'nvim-treesitter/nvim-treesitter-context',
  lazy = true,
  config = function()
    require('nvim-treesitter.configs').setup {
      context = {
        enable = true,
        max_lines = 1,
        multiline_threshold = 1,
      },
    }
  end,
}
