impulse.nvim
===

`impulse.nvim` is a neovim plugin for viewing Notion.so pages.

It is written in [Yuescript][1].


Functions
===

- `impulse.search("query")` - search for pages with "query" in the title (uses telescope)
- `impulse.menu_search()` - pop up a menu at cursor that you can use to type in a query ad-hoc 
- `impulse.follow_link()` follow page links in a document (only works on pages)

Example keybinds in .vim

```
nnoremap <leader>vs :lua require("impulse").menu_search()<CR>
nnoremap <leader>vl :lua require("impulse").follow_link()<CR>
```

Install
===

impulse requires `http` from luarocks.
also, idk man, i use packer.

In yue/moonscript:

```moonscript
packer.startup (use) ->
  use_rocks "http"

  use {
    "chrsm/impulse.nvim"
    config: ->
      require("impulse").setup!
    requires:
      * "nvim-lua/plenary.nvim"
      * "nvim-telescope/telescope.nvim"
  }
```

In lua:

```lua
packer.startup(function(use)
  use_rocks("http")

  use {
    "chrsm/impulse.nvim",
    config = function()
      require("impulse").setup({})
    end,
    requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  }
end)
```


Configuration Options
===

```moonscript
{
  api_key: "NOTION API KEY"
  always_refetch: false or true
}
```


Contributing
===

- don't be an ass
- use [yue][1]
- write decent commit messages
- ???


[1]: https://github.com/pigpigyyy/Yuescript
