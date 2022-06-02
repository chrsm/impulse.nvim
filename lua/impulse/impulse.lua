-- [yue]: ./impulse/impulse.yue
local _module_0 = nil -- 1
local request = require("http.request") -- 1
local Notion = require("impulse.api") -- 3
local Buffer = require("impulse.buffer") -- 4
local NTypes = require("impulse.types") -- 5
local to_md = require("impulse.markdown") -- 6
local menu = require("impulse.menu") -- 7
local buffers = { } -- 9
local create_buffer -- 10
create_buffer = function(block_id) -- 10
  if not buffers[block_id] then -- 11
    buffers[block_id] = Buffer() -- 11
  end -- 11
  return buffers[block_id] -- 13
end -- 10
local impulse = { -- 16
  client = nil, -- 16
  config = { -- 19
    api_key = os.getenv("NOTION_SECRET"), -- 19
    always_refetch = false -- 20
  } -- 18
} -- 15
impulse.search = function(query) -- 23
  if query == nil then -- 23
    query = "" -- 23
  end -- 23
  if not impulse.client then -- 24
    error("impulse.nvim: setup must be called first") -- 25
  end -- 24
  local resp = impulse.client:search(query) -- 27
  local r = { } -- 29
  local _list_0 = resp.results -- 30
  for _index_0 = 1, #_list_0 do -- 30
    local v = _list_0[_index_0] -- 30
    r[#r + 1] = { -- 32
      id = v.id, -- 32
      title = v.properties.title.title[1].plain_text, -- 33
      url = v.url -- 34
    } -- 31
  end -- 34
  if not (#query > 0) then -- 36
    query = "(none)" -- 36
  end -- 36
  return menu.page(r, { -- 38
    title = "query results: " .. tostring(query), -- 38
    make_entry = function(v) -- 39
      return { -- 40
        value = v, -- 40
        display = v.title, -- 40
        ordinal = v.title -- 40
      } -- 40
    end, -- 39
    make_title = function(v) -- 41
      return v.title -- 42
    end, -- 41
    select = function(v) -- 43
      local b -- 44
      do -- 44
        local _with_0 = create_buffer(v.value.id) -- 44
        _with_0:set_name(v.display) -- 45
        if _with_0:empty() or impulse.config.always_refetch then -- 46
          _with_0:set_content(to_md((impulse._fetch(v.value.id)))) -- 47
        end -- 46
        _with_0:focus() -- 48
        b = _with_0 -- 44
      end -- 44
    end -- 43
  }) -- 49
end -- 23
impulse.menu_search = function() -- 51
  return menu.input({ -- 53
    title = "impulse: Notion Search Query", -- 53
    input_text = "Search Query: ", -- 54
    on_submit = function(v) -- 55
      return impulse.search(v) -- 56
    end -- 55
  }) -- 57
end -- 51
impulse._fetch = function(id) -- 60
  if not impulse.client then -- 61
    error("impulse.nvim: setup must be called first") -- 62
  end -- 61
  if not id then -- 64
    error("impulse.nvim: no block id specified") -- 65
  end -- 64
  local cur, more = 0, false -- 67
  local blocks = { } -- 68
  repeat -- 69
    local resp = impulse.client:get_blocks(id, cur) -- 70
    local _list_0 = resp.results -- 72
    for _index_0 = 1, #_list_0 do -- 72
      local b = _list_0[_index_0] -- 72
      local block = NTypes.to_type(b.type, b) -- 73
      if block:has_children() and block.type ~= "child_page" and block.type ~= "child_database" then -- 75
        block.children = impulse._fetch(b.id) -- 76
      end -- 75
      blocks[#blocks + 1] = block -- 78
    end -- 79
    more = resp.has_more -- 80
    cur = resp.next_cursor -- 81
  until more == false -- 82
  return blocks -- 84
end -- 60
local link_pats = { -- 87
  { -- 87
    gmatch = "(%[.+%]%(impulse://[^/]+/[^%)]+%))", -- 87
    match = function(v) -- 87
      local name, typ, block_id = v:match("%[(.+)%]%(impulse://([^/]+)/([^%)]+)%)") -- 88
      return { -- 89
        name, -- 89
        typ, -- 89
        block_id -- 89
      } -- 89
    end -- 87
  }, -- 87
  { -- 91
    gmatch = "(%[.+%]%(https://www%.notion%.so/.+%))", -- 91
    match = function(v) -- 91
      local block_id = v:match("[/-]([a-zA-Z0-9]+)%)") -- 92
      return { -- 93
        "", -- 93
        "page", -- 93
        block_id -- 93
      } -- 93
    end -- 91
  } -- 91
} -- 86
impulse.follow_link = function() -- 96
  local ln = vim.api.nvim_get_current_line() -- 98
  local col = vim.fn.col(".") -- 99
  local name, typ, block_id = nil, nil, nil -- 102
  for _index_0 = 1, #link_pats do -- 104
    local pats = link_pats[_index_0] -- 104
    for v in ln:gmatch(pats.gmatch) do -- 105
      local s, e = ln:find(v, 1, true) -- 107
      if s <= col and e >= col then -- 110
        do -- 111
          local _obj_0 = pats.match(v) -- 111
          name, typ, block_id = _obj_0[1], _obj_0[2], _obj_0[3] -- 111
        end -- 111
      end -- 110
    end -- 111
  end -- 111
  if not block_id then -- 113
    vim.notify("impulse.nvim: no link found on current line") -- 114
    return -- 115
  end -- 113
  if typ ~= "page" then -- 117
    error("impulse.nvim: currently, cannot follow link to non-page (" .. tostring(typ) .. ", " .. tostring(block_id) .. ")") -- 118
  end -- 117
  local pg = impulse.client:get_page(block_id) -- 121
  if not pg then -- 122
    error("impulse.nvim: unable to retrieve page " .. tostring(block_id)) -- 123
  end -- 122
  name = pg.properties.title.title[1].plain_text -- 125
  local content = impulse._fetch(block_id) -- 129
  local b -- 131
  do -- 131
    local _with_0 = create_buffer(block_id) -- 131
    _with_0:set_name((name or "(no name found)")) -- 132
    if _with_0:empty() or impulse.config.always_refetch then -- 133
      _with_0:set_content(to_md((impulse._fetch(block_id)))) -- 134
    end -- 133
    _with_0:focus() -- 135
    b = _with_0 -- 131
  end -- 131
end -- 96
impulse.setup = function(opt) -- 138
  if opt == nil then -- 138
    opt = { } -- 138
  end -- 138
  impulse.config = vim.tbl_deep_extend("force", impulse.config, opt) -- 139
  impulse.client = Notion(impulse.config.api_key) -- 140
end -- 138
_module_0 = impulse -- 142
return _module_0 -- 142
