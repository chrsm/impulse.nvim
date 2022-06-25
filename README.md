impulse.nvim
===

`impulse.nvim` is a neovim plugin for viewing Notion.so pages. It converts
Notion blocks to Markdown for viewing. It is written in [Yuescript][1].

Currently, impulse does not support updating Notion pages. I'm still working on
implementing that functionality. Please feel free to contribute!


Screenshots
===


### Search Results

![search](https://raw.githubusercontent.com/chrsm/impulse.nvim/assets/img/impulse-search-results.png)


### Page View

![view](https://raw.githubusercontent.com/chrsm/impulse.nvim/assets/img/impulse-to-markdown.png)


Before Installing
===

In order to use this plugin, you need to have a [Notion integration][2].

Only admins of a Notion workspace can set up integrations, and an integration
**must be invited** to the page you wish for it to be able to retrieve.
It's a bit silly, but if you are organized in your Notion use, you should be
able to invite it to a top-level "page" and give it access to everything
underneath.

The way impulse.nvim currently interacts with Notion is purely read-only, so
your integration can drop update/insert permissions for now. If such
functionality is ever implemented, you can update the permissions easily.


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

In yue/moonscript:

```moonscript
packer.startup (use) ->
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
  -- Your notion API key. 
  -- Get one by creating an integration here: https://www.notion.so/my-integrations
  -- This plugin does not update or modify any pages, so you can set
  -- "Read content" as the only option if you prefer.
  --
  -- It is possible that impulse will be updated with write abilities at some
  -- point.
  --
  -- DEFAULT: os.getenv "NOTION_SECRET"
  api_key: "NOTION API KEY"

  -- If always_refetch is true, every time you search-and-select or follow a
  -- link, that page's block set will be pulled again. Useful if you are
  -- following live updates.
  --
  -- DEFAULT: false
  always_refetch: false or true

  -- Whether or not to allow `follow_link` to open a non-impulse URL.
  -- If false, nothing will happen with follow_link.
  -- If true, impulse will use xdg-open.
  -- If a path is specified or name of a browser in $PATH, impulse will use it.
  --
  -- DEFAULT: false
  open_in_browser: false, true or "string browser"
}
```


Contributing
===

- don't be an ass
- use [yue][1]
- write decent commit messages
- ???


[1]: https://github.com/pigpigyyy/Yuescript
[2]: https://www.notion.so/my-integrations
