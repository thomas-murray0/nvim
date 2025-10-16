local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local extras = require 'luasnip.extras'
local rep = extras.rep
local fmt = require('luasnip.extras.fmt').fmt
-- look up teej video on fmta -> 'https://www.youtube.com/watch?v=aNWx-ym7jjI'

-- note on the below require statement
-- when you alter snippet and reload the config in a file, the snippet gets defined under that name twice or more which is annoying and you have to reload the .py or whatever file to have the snippet only defined once. The below clears all snippets each time it is source for a given file type and makes alter snippets and testing easier however it gets rid of the vscode preloaded ones too which is probably not optimal and should be turned off after testing
-- require('luasnip.session.snippet_collection').clear_snippets 'python'

-- useful notes
-- snippets for all files go in the 'all table' while snippets for specific file types go under that file type name
-- snippets are named in the first arg of s(...)
-- t is a text node which means this is the text the snippet will expand to
-- i is an insert node; start at 1 for the first one and end with 0 for the node the cursor should go to when the snippet is completed
-- rep repeats a snippet from another numbered insert node and both show as the text changes, this is in the cmp.lua setup function (TextChanged,TextChangedI)

-- other nodes -> choice, function, and dynamic nodes
-- also snippet nodes???

-- !! Search name of Lang !! --

-- All
ls.add_snippets('all', {
  s('goodnight', {
    t 'print("goodnight ',
    i(1),
    t ' moon") #',
    rep(1),
    i(0),
  }),
})

-- C
ls.add_snippets('c', {
  s(
    'imports',
    fmt(
      [[
    #include <stdint.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>
    #include <unistd.h>
      ]],
      {},
      {
        indent_string = '',
      }
    )
  ),
})

-- Python
ls.add_snippets('python', {
  s('forenum', {
    t 'for (idx, ',
    i(1),
    t ') in enumerate(',
    i(2),
    t { '):', '\t' },
    i(0),
  }),
  s('some new snippet', {
    t 'making new snippets bruh',
  }),
})

-- Zig
ls.add_snippets('zig', {
  s(
    'stdout',
    fmt(
      [[
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer: std.fs.File.Writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout: *std.Io.Writer = &stdout_writer.interface;
      ]],
      {},
      {
        indent_string = '',
      }
    )
  ),
})

ls.add_snippets('zig', {
  s(
    'stdin',
    fmt(
      [[
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader: std.fs.File.Reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin: *std.Io.Reader = &stdin_reader.interface;
      ]],
      {},
      {
        indent_string = '',
      }
    )
  ),
})

-- Go
-- ls.add_snippets("go", {
--   s('err', {
--     t 'fmt.Errorf(',
--     i(1),
--     t ')',
--     i(0),
--   }),
-- })
