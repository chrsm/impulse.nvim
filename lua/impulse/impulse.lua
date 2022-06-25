-- [yue]: ./impulse/impulse.yue
local _module_0 = nil -- 1
local Job = require("plenary.job") -- 1
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
    always_refetch = false, -- 20
    open_in_browser = false -- 25
  } -- 18
} -- 15
impulse.search = function(query) -- 28
  if query == nil then -- 28
    query = "" -- 28
  end -- 28
  if not impulse.client then -- 29
    error("impulse.nvim: setup must be called first") -- 30
  end -- 29
  local resp = impulse.client:search(query) -- 32
  local r = { } -- 34
  local _list_0 = resp.results -- 35
  for _index_0 = 1, #_list_0 do -- 35
    local v = _list_0[_index_0] -- 35
    r[#r + 1] = { -- 37
      id = v.id, -- 37
      title = v.properties.title.title[1].plain_text, -- 38
      url = v.url -- 39
    } -- 36
  end -- 39
  if not (#query > 0) then -- 41
    query = "(none)" -- 41
  end -- 41
  return menu.page(r, { -- 43
    title = "query results: " .. tostring(query), -- 43
    make_entry = function(v) -- 44
      return { -- 45
        value = v, -- 45
        display = v.title, -- 45
        ordinal = v.title -- 45
      } -- 45
    end, -- 44
    make_title = function(v) -- 46
      return v.title -- 47
    end, -- 46
    select = function(v) -- 48
      local b -- 49
      do -- 49
        local _with_0 = create_buffer(v.value.id) -- 49
        _with_0:set_name(v.display) -- 50
        if _with_0:empty() or impulse.config.always_refetch then -- 51
          _with_0:set_content(to_md((impulse._fetch(v.value.id)))) -- 52
        end -- 51
        _with_0:focus() -- 53
        b = _with_0 -- 49
      end -- 49
    end -- 48
  }) -- 54
end -- 28
impulse.menu_search = function() -- 56
  return menu.input({ -- 58
    title = "impulse: Notion Search Query", -- 58
    input_text = "Search Query: ", -- 59
    on_submit = function(v) -- 60
      return impulse.search(v) -- 61
    end -- 60
  }) -- 62
end -- 56
impulse._fetch = function(id) -- 65
  if not impulse.client then -- 66
    error("impulse.nvim: setup must be called first") -- 67
  end -- 66
  if not id then -- 69
    error("impulse.nvim: no block id specified") -- 70
  end -- 69
  local cur, more = 0, false -- 72
  local blocks = { } -- 73
  repeat -- 74
    local resp = impulse.client:get_blocks(id, cur) -- 75
    local _list_0 = resp.results -- 77
    for _index_0 = 1, #_list_0 do -- 77
      local b = _list_0[_index_0] -- 77
      local block = NTypes.to_type(b.type, b) -- 78
      if block:has_children() then -- 80
        do -- 81
          local _exp_0 = block.type -- 81
          if "child_page" == _exp_0 then -- 82
            block.children = { } -- 83
          elseif "child_database" == _exp_0 then -- 84
            block.children = { } -- 85
          elseif "synced_block" == _exp_0 then -- 86
            block.children = impulse._fetch(block.content.synced_from.block_id) -- 87
          else -- 89
            block.children = impulse._fetch(b.id) -- 89
          end -- 89
        end -- 89
      end -- 80
      blocks[#blocks + 1] = block -- 91
    end -- 92
    more = resp.has_more -- 93
    cur = resp.next_cursor -- 94
  until more == false -- 95
  return blocks -- 97
end -- 65
local link_pats = { -- 100
  { -- 100
    gmatch = "(%[.+%]%(impulse://[^/]+/[^%)]+%))", -- 100
    match = function(v) -- 100
      local name, typ, block_id = v:match("%[(.+)%]%(impulse://([^/]+)/([^%)]+)%)") -- 101
      return { -- 102
        name, -- 102
        typ, -- 102
        block_id -- 102
      } -- 102
    end -- 100
  }, -- 100
  { -- 104
    gmatch = "(%[.+%]%(https://www%.notion%.so/.+%))", -- 104
    match = function(v) -- 104
      local block_id = v:match("[/-]([a-zA-Z0-9]+)%)") -- 105
      return { -- 106
        "", -- 106
        "page", -- 106
        block_id -- 106
      } -- 106
    end -- 104
  }, -- 104
  { -- 108
    gmatch = "(%[.+%]%(.+%))", -- 108
    match = function(v) -- 108
      local url = v:match("%((.+)%)") -- 109
      return { -- 110
        "", -- 110
        "open-link", -- 110
        url -- 110
      } -- 110
    end -- 108
  } -- 108
} -- 99
impulse.follow_link = function() -- 113
  local ln = vim.api.nvim_get_current_line() -- 115
  local col = vim.fn.col(".") -- 116
  local name, typ, block_id = nil, nil, nil -- 119
  for _index_0 = 1, #link_pats do -- 121
    local pats = link_pats[_index_0] -- 121
    for v in ln:gmatch(pats.gmatch) do -- 122
      local s, e = ln:find(v, 1, true) -- 124
      if s <= col and e >= col then -- 127
        do -- 128
          local _obj_0 = pats.match(v) -- 128
          name, typ, block_id = _obj_0[1], _obj_0[2], _obj_0[3] -- 128
        end -- 128
      end -- 127
    end -- 128
  end -- 128
  if not block_id then -- 130
    vim.notify("impulse.nvim: no link found on current line") -- 131
    return -- 132
  end -- 130
  if typ ~= "page" and typ ~= "open-link" then -- 134
    error("impulse.nvim: currently, cannot follow link to non-page (" .. tostring(typ) .. ", " .. tostring(block_id) .. ")") -- 135
  end -- 134
  if typ == "open-link" then -- 137
    do -- 138
      local _with_0 = impulse.config -- 138
      if not _with_0.open_in_browser then -- 139
        error("impulse.nvim: open_in_browser set to " .. tostring(impulse.config.open_in_browser)) -- 140
      end -- 139
      local exec = "xdg-open" -- 142
      if (type(_with_0.open_in_browser)) == "string" then -- 143
        exec = _with_0.open_in_browser -- 144
      end -- 143
      local j = Job:new({ -- 146
        command = exec, -- 146
        args = { -- 146
          block_id -- 146
        } -- 146
      }) -- 146
      j:start() -- 147
    end -- 138
    return -- 148
  end -- 137
  local pg = impulse.client:get_page(block_id) -- 151
  if not pg then -- 152
    error("impulse.nvim: unable to retrieve page " .. tostring(block_id)) -- 153
  end -- 152
  name = pg.properties.title.title[1].plain_text -- 155
  local content = impulse._fetch(block_id) -- 159
  local b -- 161
  do -- 161
    local _with_0 = create_buffer(block_id) -- 161
    _with_0:set_name((name or "(no name found)")) -- 162
    if _with_0:empty() or impulse.config.always_refetch then -- 163
      _with_0:set_content(to_md((impulse._fetch(block_id)))) -- 164
    end -- 163
    _with_0:focus() -- 165
    b = _with_0 -- 161
  end -- 161
end -- 113
impulse.setup = function(opt) -- 168
  if opt == nil then -- 168
    opt = { } -- 168
  end -- 168
  impulse.config = vim.tbl_deep_extend("force", impulse.config, opt) -- 169
  impulse.client = Notion(impulse.config.api_key) -- 170
end -- 168
_module_0 = impulse -- 172
return _module_0 -- 172
