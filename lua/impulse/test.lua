-- [yue]: ./impulse/test.yue
local Notion = require("api") -- 1
local typ = require("types") -- 2
local inspect = require("inspect") -- 3
local n = Notion(os.getenv("NOTION_SECRET")) -- 5
local pgs = n:search("wtf dont show me this shit ok") -- 7
print(inspect(pgs)) -- 9
error("x") -- 10
local pg = nil -- 12
local _list_0 = pgs.results -- 13
for _index_0 = 1, #_list_0 do -- 13
  local v = _list_0[_index_0] -- 13
  print(inspect(v)) -- 14
  if v.object == "page" and v.properties.title.title[1].plain_text == "Getting Started" then -- 15
    pg = v -- 16
  end -- 15
end -- 16
if not pg then -- 18
  error("no page found") -- 19
end -- 18
local blocks = n:get_blocks(pg.id) -- 21
local to_md -- 24
to_md = function(blocks) -- 24
  if blocks == nil then -- 24
    blocks = { } -- 24
  end -- 24
  blocks.results = blocks.results or { } -- 25
  local _list_1 = blocks.results -- 27
  for _index_0 = 1, #_list_1 do -- 27
    local v = _list_1[_index_0] -- 27
    local b = typ.to_type(v.type, v) -- 28
    if not b then -- 29
      error("wtf " .. tostring(v.type)) -- 30
    end -- 29
    if b then -- 32
      print(b:to_md()) -- 33
      if b:has_children() and b.type ~= "child_page" and b.type ~= "child_database" then -- 36
        local child_blocks = n:get_blocks(b:get_id()) -- 37
        to_md(child_blocks) -- 38
      end -- 36
    end -- 32
  end -- 38
end -- 24
return to_md(blocks) -- 40
