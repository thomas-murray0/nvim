-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()
      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode', icon = { icon = '', color = 'purple' } },
        { '<leader>d', group = '[D]ebug', icon = { icon = '', color = 'grey' } },
        { '<leader>e', group = '[E]rror', icon = { icon = '󰓙', color = 'red' } },
        { '<leader>g', group = 'Git Hunk', mode = { 'n', 'v' } },
        { '<leader>h', group = '[H]arpoon', icon = { icon = '󰡨', color = 'yellow' } },
        { '<leader>l', group = '[L]SP', icon = { icon = 'λ', color = 'azure' } },
        { '<leader>s', group = '[S]earch', icon = { icon = '', color = 'blue' } },
        { '<leader>t', group = '[T]oggle', icon = { icon = '', color = 'cyan' } },
        { '<leader>x', group = 'Source [X]', icon = { icon = '  ', color = 'green' } },
      }
    end,
    opts = {
      -- turn off automatic popup when <leader> is pressed
      triggers = {},
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
