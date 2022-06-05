-- [yue]: ./impulse/impulse.yue
local _module_0 = nil -- 1
local request = require("http.request") -- 1
local Job = require("plenary.job") -- 3
local Notion = require("impulse.api") -- 5
local Buffer = require("impulse.buffer") -- 6
local NTypes = require("impulse.types") -- 7
local to_md = require("impulse.markdown") -- 8
local menu = require("impulse.menu") -- 9
local buffers = { } -- 11
local create_buffer -- 12
create_buffer = function(block_id) -- 12
  if not buffers[block_id] then -- 13
    buffers[block_id] = Buffer() -- 13
  end -- 13
  return buffers[block_id] -- 15
end -- 12
local impulse = { -- 18
  client = nil, -- 18
  config = { -- 21
    api_key = os.getenv("NOTION_SECRET"), -- 21
    always_refetch = false, -- 22
    open_in_browser = false -- 27
  } -- 20
} -- 17
impulse.search = function(query) -- 30
  if query == nil then -- 30
    query = "" -- 30
  end -- 30
  if not impulse.client then -- 31
    error("impulse.nvim: setup must be called first") -- 32
  end -- 31
  local resp = impulse.client:search(query) -- 34
  local r = { } -- 36
  local _list_0 = resp.results -- 37
  for _index_0 = 1, #_list_0 do -- 37
    local v = _list_0[_index_0] -- 37
    r[#r + 1] = { -- 39
      id = v.id, -- 39
      title = v.properties.title.title[1].plain_text, -- 40
      url = v.url -- 41
    } -- 38
  end -- 41
  if not (#query > 0) then -- 43
    query = "(none)" -- 43
  end -- 43
  return menu.page(r, { -- 45
    title = "query results: " .. tostring(query), -- 45
    make_entry = function(v) -- 46
      return { -- 47
        value = v, -- 47
        display = v.title, -- 47
        ordinal = v.title -- 47
      } -- 47
    end, -- 46
    make_title = function(v) -- 48
      return v.title -- 49
    end, -- 48
    select = function(v) -- 50
      local b -- 51
      do -- 51
        local _with_0 = create_buffer(v.value.id) -- 51
        _with_0:set_name(v.display) -- 52
        if _with_0:empty() or impulse.config.always_refetch then -- 53
          _with_0:set_content(to_md((impulse._fetch(v.value.id)))) -- 54
        end -- 53
        _with_0:focus() -- 55
        b = _with_0 -- 51
      end -- 51
    end -- 50
  }) -- 56
end -- 30
impulse.menu_search = function() -- 58
  return menu.input({ -- 60
    title = "impulse: Notion Search Query", -- 60
    input_text = "Search Query: ", -- 61
    on_submit = function(v) -- 62
      return impulse.search(v) -- 63
    end -- 62
  }) -- 64
end -- 58
impulse._fetch = function(id) -- 67
  if not impulse.client then -- 68
    error("impulse.nvim: setup must be called first") -- 69
  end -- 68
  if not id then -- 71
    error("impulse.nvim: no block id specified") -- 72
  end -- 71
  local cur, more = 0, false -- 74
  local blocks = { } -- 75
  repeat -- 76
    local resp = impulse.client:get_blocks(id, cur) -- 77
    local _list_0 = resp.results -- 79
    for _index_0 = 1, #_list_0 do -- 79
      local b = _list_0[_index_0] -- 79
      local block = NTypes.to_type(b.type, b) -- 80
      if block:has_children() then -- 82
        do -- 83
          local _exp_0 = block.type -- 83
          if "child_page" == _exp_0 then -- 84
            block.children = { } -- 85
          elseif "child_database" == _exp_0 then -- 86
            block.children = { } -- 87
          elseif "synced_block" == _exp_0 then -- 88
            block.children = impulse._fetch(block.content.synced_from.block_id) -- 89
          else -- 91
            block.children = impulse._fetch(b.id) -- 91
          end -- 91
        end -- 91
      end -- 82
      blocks[#blocks + 1] = block -- 93
    end -- 94
    more = resp.has_more -- 95
    cur = resp.next_cursor -- 96
  until more == false -- 97
  return blocks -- 99
end -- 67
local link_pats = { -- 102
  { -- 102
    gmatch = "(%[.+%]%(impulse://[^/]+/[^%)]+%))", -- 102
    match = function(v) -- 102
      local name, typ, block_id = v:match("%[(.+)%]%(impulse://([^/]+)/([^%)]+)%)") -- 103
      return { -- 104
        name, -- 104
        typ, -- 104
        block_id -- 104
      } -- 104
    end -- 102
  }, -- 102
  { -- 106
    gmatch = "(%[.+%]%(https://www%.notion%.so/.+%))", -- 106
    match = function(v) -- 106
      local block_id = v:match("[/-]([a-zA-Z0-9]+)%)") -- 107
      return { -- 108
        "", -- 108
        "page", -- 108
        block_id -- 108
      } -- 108
    end -- 106
  }, -- 106
  { -- 110
    gmatch = "(%[.+%]%(.+%))", -- 110
    match = function(v) -- 110
      local url = v:match("%((.+)%)") -- 111
      return { -- 112
        "", -- 112
        "open-link", -- 112
        url -- 112
      } -- 112
    end -- 110
  } -- 110
} -- 101
impulse.follow_link = function() -- 115
  local ln = vim.api.nvim_get_current_line() -- 117
  local col = vim.fn.col(".") -- 118
  local name, typ, block_id = nil, nil, nil -- 121
  for _index_0 = 1, #link_pats do -- 123
    local pats = link_pats[_index_0] -- 123
    for v in ln:gmatch(pats.gmatch) do -- 124
      local s, e = ln:find(v, 1, true) -- 126
      if s <= col and e >= col then -- 129
        do -- 130
          local _obj_0 = pats.match(v) -- 130
          name, typ, block_id = _obj_0[1], _obj_0[2], _obj_0[3] -- 130
        end -- 130
      end -- 129
    end -- 130
  end -- 130
  if not block_id then -- 132
    vim.notify("impulse.nvim: no link found on current line") -- 133
    return -- 134
  end -- 132
  if typ ~= "page" and typ ~= "open-link" then -- 136
    error("impulse.nvim: currently, cannot follow link to non-page (" .. tostring(typ) .. ", " .. tostring(block_id) .. ")") -- 137
  end -- 136
  if typ == "open-link" then -- 139
    do -- 140
      local _with_0 = impulse.config -- 140
      if not _with_0.open_in_browser then -- 141
        error("impulse.nvim: open_in_browser set to " .. tostring(impulse.config.open_in_browser)) -- 142
      end -- 141
      local exec = "xdg-open" -- 144
      if (type(_with_0.open_in_browser)) == "string" then -- 145
        exec = _with_0.open_in_browser -- 146
      end -- 145
      local j = Job:new({ -- 148
        command = exec, -- 148
        args = { -- 148
          block_id -- 148
        } -- 148
      }) -- 148
      j:start() -- 149
    end -- 140
    return -- 150
  end -- 139
  local pg = impulse.client:get_page(block_id) -- 153
  if not pg then -- 154
    error("impulse.nvim: unable to retrieve page " .. tostring(block_id)) -- 155
  end -- 154
  name = pg.properties.title.title[1].plain_text -- 157
  local content = impulse._fetch(block_id) -- 161
  local b -- 163
  do -- 163
    local _with_0 = create_buffer(block_id) -- 163
    _with_0:set_name((name or "(no name found)")) -- 164
    if _with_0:empty() or impulse.config.always_refetch then -- 165
      _with_0:set_content(to_md((impulse._fetch(block_id)))) -- 166
    end -- 165
    _with_0:focus() -- 167
    b = _with_0 -- 163
  end -- 163
end -- 115
impulse.setup = function(opt) -- 170
  if opt == nil then -- 170
    opt = { } -- 170
  end -- 170
  impulse.config = vim.tbl_deep_extend("force", impulse.config, opt) -- 171
  impulse.client = Notion(impulse.config.api_key) -- 172
end -- 170
_module_0 = impulse -- 174
return _module_0 -- 174
