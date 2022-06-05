-- [yue]: ./impulse/markdown.yue
local _module_0 = nil -- 1
local NTypes = require("impulse.types") -- 1
local to_md -- 3
to_md = function(blocks, ident) -- 3
  if ident == nil then -- 3
    ident = 0 -- 3
  end -- 3
  local r = { } -- 4
  local spc = "" -- 6
  if ident > 0 then -- 7
    spc = string.rep(" ", ident) -- 8
  end -- 7
  for _index_0 = 1, #blocks do -- 10
    local v = blocks[_index_0] -- 10
    local _continue_0 = false -- 11
    repeat -- 11
      if not v then -- 11
        error(vim.inspect(blocks)) -- 12
      end -- 11
      local md = v:to_md() -- 14
      if not md then -- 15
        _continue_0 = true -- 15
        break -- 15
      end -- 15
      if v.type == "table" then -- 17
        ident = ident - 2 -- 19
      end -- 17
      if (type(md)) == "table" then -- 21
        for _index_1 = 1, #md do -- 22
          local ent = md[_index_1] -- 22
          r[#r + 1] = (spc .. ent) -- 22
        end -- 22
      else -- 24
        r[#r + 1] = spc .. md -- 24
      end -- 21
      if v.children and v.type ~= "child_page" and v.type ~= "child_database" then -- 26
        local rch = to_md(v.children, ident + 2) -- 27
        if v.type == "table" and v.content.has_column_header then -- 30
          local head = "|---" -- 31
          head = head .. string.rep("|---", v.content.table_width - 1) -- 32
          head = head .. "|" -- 33
          table.insert(rch, 2, head) -- 34
        end -- 30
        for _index_1 = 1, #rch do -- 36
          local v = rch[_index_1] -- 36
          r[#r + 1] = v -- 36
        end -- 36
        if v.type == "synced_block" then -- 39
          r[#r + 1] = "[end-synced-block]" -- 40
        end -- 39
      end -- 26
      _continue_0 = true -- 11
    until true -- 40
    if not _continue_0 then -- 40
      break -- 40
    end -- 40
  end -- 40
  return r -- 42
end -- 3
_module_0 = to_md -- 44
return _module_0 -- 44
