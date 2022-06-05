-- [yue]: ./impulse/types.yue
local _module_0 = nil -- 1
local inspect -- 1
inspect = function(v) -- 1
  local oinspect = (function() -- 2
    local _obj_0 = vim -- 2
    if _obj_0 ~= nil then -- 2
      return _obj_0.inspect -- 2
    end -- 2
    return nil -- 2
  end)() or require("inspect") -- 2
  return oinspect(v, { -- 4
    newline = "@", -- 4
    indent = "++" -- 4
  }) -- 4
end -- 1
local iter_rtext -- 6
iter_rtext = function(content) -- 6
  if content == nil then -- 6
    content = { } -- 6
  end -- 6
  local texts -- 7
  if content.rich_text then -- 7
    texts = content.rich_text -- 8
  else -- 10
    texts = content.text -- 10
  end -- 7
  if not texts then -- 12
    return "no usable content in " .. tostring(inspect(content)) -- 13
  end -- 12
  local txt = { } -- 15
  for i, v in ipairs(texts) do -- 16
    local tc = v.plain_text -- 17
    local href -- 18
    if v.href ~= vim.NIL then -- 18
      href = v.href -- 18
    end -- 18
    do -- 20
      local _with_0 = v.annotations -- 20
      if _with_0 ~= nil then -- 20
        if _with_0.bold then -- 21
          tc = "**" .. tostring(tc) .. "**" -- 22
        end -- 21
        if _with_0.italic then -- 23
          tc = "_" .. tostring(tc) .. "_" -- 24
        end -- 23
        if _with_0.underline then -- 25
          tc = "<ins>" .. tostring(tc) .. "</ins>" -- 26
        end -- 25
        if _with_0.strikethrough then -- 27
          tc = "~~" .. tostring(tc) .. "~~" -- 28
        end -- 27
        if _with_0.code then -- 29
          tc = "`" .. tostring(tc) .. "`" -- 30
        end -- 29
      end -- 20
    end -- 20
    if not href then -- 33
      txt[#txt + 1] = tostring(tc) -- 34
    else -- 36
      txt[#txt + 1] = "[" .. tostring(tc) .. "](" .. tostring(href) .. ")" -- 36
    end -- 33
  end -- 36
  return txt -- 38
end -- 6
local get_file_link -- 40
get_file_link = function(content) -- 40
  if content.type == "external" then -- 41
    return content.external.url -- 42
  else -- 44
    return content.file.url -- 44
  end -- 41
end -- 40
local Block -- 46
do -- 46
  local _class_0 -- 46
  local _base_0 = { -- 46
    get_id = function(self) -- 56
      return self.properties.id -- 56
    end, -- 57
    has_children = function(self) -- 57
      return self.properties.has_children -- 57
    end, -- 58
    to_md = function(self) -- 58
      return error("unsupported block->md") -- 58
    end -- 46
  } -- 46
  if _base_0.__index == nil then -- 46
    _base_0.__index = _base_0 -- 46
  end -- 58
  _class_0 = setmetatable({ -- 46
    __init = function(self, type, properties) -- 47
      if properties == nil then -- 47
        properties = { } -- 47
      end -- 47
      self.can_md = false -- 48
      self.type = type -- 49
      self.properties = properties -- 50
      self.children = properties.children or { } -- 51
      if self.properties then -- 53
        self.content = self.properties[self.type] -- 54
      end -- 53
    end, -- 46
    __base = _base_0, -- 46
    __name = "Block" -- 46
  }, { -- 46
    __index = _base_0, -- 46
    __call = function(cls, ...) -- 46
      local _self_0 = setmetatable({ }, _base_0) -- 46
      cls.__init(_self_0, ...) -- 46
      return _self_0 -- 46
    end -- 46
  }) -- 46
  _base_0.__class = _class_0 -- 46
  Block = _class_0 -- 46
end -- 58
local Unsupported -- 61
do -- 61
  local _class_0 -- 61
  local _parent_0 = Block -- 61
  local _base_0 = { -- 61
    to_md = function(self) -- 64
      return "[unsupported-" .. tostring(self:get_id()) .. "](impulse://unsupported/" .. tostring(self:get_id()) .. ")" -- 64
    end -- 61
  } -- 61
  if _base_0.__index == nil then -- 61
    _base_0.__index = _base_0 -- 61
  end -- 64
  setmetatable(_base_0, _parent_0.__base) -- 61
  _class_0 = setmetatable({ -- 61
    __init = function(self, props) -- 62
      return _class_0.__parent.__init(self, "unsupported", props) -- 63
    end, -- 61
    __base = _base_0, -- 61
    __name = "Unsupported", -- 61
    __parent = _parent_0 -- 61
  }, { -- 61
    __index = function(cls, name) -- 61
      local val = rawget(_base_0, name) -- 61
      if val == nil then -- 61
        local parent = rawget(cls, "__parent") -- 61
        if parent then -- 61
          return parent[name] -- 61
        end -- 61
      else -- 61
        return val -- 61
      end -- 61
    end, -- 61
    __call = function(cls, ...) -- 61
      local _self_0 = setmetatable({ }, _base_0) -- 61
      cls.__init(_self_0, ...) -- 61
      return _self_0 -- 61
    end -- 61
  }) -- 61
  _base_0.__class = _class_0 -- 61
  if _parent_0.__inherited then -- 61
    _parent_0.__inherited(_parent_0, _class_0) -- 61
  end -- 61
  Unsupported = _class_0 -- 61
end -- 64
local Paragraph -- 66
do -- 66
  local _class_0 -- 66
  local _parent_0 = Block -- 66
  local _base_0 = { -- 66
    to_md = function(self) -- 71
      return table.concat((iter_rtext(self.content))) -- 72
    end -- 66
  } -- 66
  if _base_0.__index == nil then -- 66
    _base_0.__index = _base_0 -- 66
  end -- 72
  setmetatable(_base_0, _parent_0.__base) -- 66
  _class_0 = setmetatable({ -- 66
    __init = function(self, props) -- 67
      _class_0.__parent.__init(self, "paragraph", props) -- 68
      self.can_md = true -- 69
    end, -- 66
    __base = _base_0, -- 66
    __name = "Paragraph", -- 66
    __parent = _parent_0 -- 66
  }, { -- 66
    __index = function(cls, name) -- 66
      local val = rawget(_base_0, name) -- 66
      if val == nil then -- 66
        local parent = rawget(cls, "__parent") -- 66
        if parent then -- 66
          return parent[name] -- 66
        end -- 66
      else -- 66
        return val -- 66
      end -- 66
    end, -- 66
    __call = function(cls, ...) -- 66
      local _self_0 = setmetatable({ }, _base_0) -- 66
      cls.__init(_self_0, ...) -- 66
      return _self_0 -- 66
    end -- 66
  }) -- 66
  _base_0.__class = _class_0 -- 66
  if _parent_0.__inherited then -- 66
    _parent_0.__inherited(_parent_0, _class_0) -- 66
  end -- 66
  Paragraph = _class_0 -- 66
end -- 72
local Heading1 -- 74
do -- 74
  local _class_0 -- 74
  local _parent_0 = Block -- 74
  local _base_0 = { -- 74
    to_md = function(self) -- 79
      return table.concat((function() -- 81
        local _tab_0 = { -- 81
          "# " -- 81
        } -- 82
        local _obj_0 = iter_rtext(self.content) -- 82
        local _idx_0 = 1 -- 82
        for _key_0, _value_0 in pairs(_obj_0) do -- 82
          if _idx_0 == _key_0 then -- 82
            _tab_0[#_tab_0 + 1] = _value_0 -- 82
            _idx_0 = _idx_0 + 1 -- 82
          else -- 82
            _tab_0[_key_0] = _value_0 -- 82
          end -- 82
        end -- 82
        return _tab_0 -- 81
      end)()) -- 83
    end -- 74
  } -- 74
  if _base_0.__index == nil then -- 74
    _base_0.__index = _base_0 -- 74
  end -- 83
  setmetatable(_base_0, _parent_0.__base) -- 74
  _class_0 = setmetatable({ -- 74
    __init = function(self, props) -- 75
      _class_0.__parent.__init(self, "heading_1", props) -- 76
      self.can_md = true -- 77
    end, -- 74
    __base = _base_0, -- 74
    __name = "Heading1", -- 74
    __parent = _parent_0 -- 74
  }, { -- 74
    __index = function(cls, name) -- 74
      local val = rawget(_base_0, name) -- 74
      if val == nil then -- 74
        local parent = rawget(cls, "__parent") -- 74
        if parent then -- 74
          return parent[name] -- 74
        end -- 74
      else -- 74
        return val -- 74
      end -- 74
    end, -- 74
    __call = function(cls, ...) -- 74
      local _self_0 = setmetatable({ }, _base_0) -- 74
      cls.__init(_self_0, ...) -- 74
      return _self_0 -- 74
    end -- 74
  }) -- 74
  _base_0.__class = _class_0 -- 74
  if _parent_0.__inherited then -- 74
    _parent_0.__inherited(_parent_0, _class_0) -- 74
  end -- 74
  Heading1 = _class_0 -- 74
end -- 83
local Heading2 -- 85
do -- 85
  local _class_0 -- 85
  local _parent_0 = Block -- 85
  local _base_0 = { -- 85
    to_md = function(self) -- 90
      return table.concat((function() -- 92
        local _tab_0 = { -- 92
          "## " -- 92
        } -- 93
        local _obj_0 = iter_rtext(self.content) -- 93
        local _idx_0 = 1 -- 93
        for _key_0, _value_0 in pairs(_obj_0) do -- 93
          if _idx_0 == _key_0 then -- 93
            _tab_0[#_tab_0 + 1] = _value_0 -- 93
            _idx_0 = _idx_0 + 1 -- 93
          else -- 93
            _tab_0[_key_0] = _value_0 -- 93
          end -- 93
        end -- 93
        return _tab_0 -- 92
      end)()) -- 94
    end -- 85
  } -- 85
  if _base_0.__index == nil then -- 85
    _base_0.__index = _base_0 -- 85
  end -- 94
  setmetatable(_base_0, _parent_0.__base) -- 85
  _class_0 = setmetatable({ -- 85
    __init = function(self, props) -- 86
      _class_0.__parent.__init(self, "heading_2", props) -- 87
      self.can_md = true -- 88
    end, -- 85
    __base = _base_0, -- 85
    __name = "Heading2", -- 85
    __parent = _parent_0 -- 85
  }, { -- 85
    __index = function(cls, name) -- 85
      local val = rawget(_base_0, name) -- 85
      if val == nil then -- 85
        local parent = rawget(cls, "__parent") -- 85
        if parent then -- 85
          return parent[name] -- 85
        end -- 85
      else -- 85
        return val -- 85
      end -- 85
    end, -- 85
    __call = function(cls, ...) -- 85
      local _self_0 = setmetatable({ }, _base_0) -- 85
      cls.__init(_self_0, ...) -- 85
      return _self_0 -- 85
    end -- 85
  }) -- 85
  _base_0.__class = _class_0 -- 85
  if _parent_0.__inherited then -- 85
    _parent_0.__inherited(_parent_0, _class_0) -- 85
  end -- 85
  Heading2 = _class_0 -- 85
end -- 94
local Heading3 -- 96
do -- 96
  local _class_0 -- 96
  local _parent_0 = Block -- 96
  local _base_0 = { -- 96
    to_md = function(self) -- 101
      return table.concat((function() -- 103
        local _tab_0 = { -- 103
          "### " -- 103
        } -- 104
        local _obj_0 = iter_rtext(self.content) -- 104
        local _idx_0 = 1 -- 104
        for _key_0, _value_0 in pairs(_obj_0) do -- 104
          if _idx_0 == _key_0 then -- 104
            _tab_0[#_tab_0 + 1] = _value_0 -- 104
            _idx_0 = _idx_0 + 1 -- 104
          else -- 104
            _tab_0[_key_0] = _value_0 -- 104
          end -- 104
        end -- 104
        return _tab_0 -- 103
      end)()) -- 105
    end -- 96
  } -- 96
  if _base_0.__index == nil then -- 96
    _base_0.__index = _base_0 -- 96
  end -- 105
  setmetatable(_base_0, _parent_0.__base) -- 96
  _class_0 = setmetatable({ -- 96
    __init = function(self, props) -- 97
      _class_0.__parent.__init(self, "heading_3", props) -- 98
      self.can_md = true -- 99
    end, -- 96
    __base = _base_0, -- 96
    __name = "Heading3", -- 96
    __parent = _parent_0 -- 96
  }, { -- 96
    __index = function(cls, name) -- 96
      local val = rawget(_base_0, name) -- 96
      if val == nil then -- 96
        local parent = rawget(cls, "__parent") -- 96
        if parent then -- 96
          return parent[name] -- 96
        end -- 96
      else -- 96
        return val -- 96
      end -- 96
    end, -- 96
    __call = function(cls, ...) -- 96
      local _self_0 = setmetatable({ }, _base_0) -- 96
      cls.__init(_self_0, ...) -- 96
      return _self_0 -- 96
    end -- 96
  }) -- 96
  _base_0.__class = _class_0 -- 96
  if _parent_0.__inherited then -- 96
    _parent_0.__inherited(_parent_0, _class_0) -- 96
  end -- 96
  Heading3 = _class_0 -- 96
end -- 105
local BulletedListItem -- 107
do -- 107
  local _class_0 -- 107
  local _parent_0 = Block -- 107
  local _base_0 = { -- 107
    to_md = function(self) -- 112
      return "* " .. tostring(self.content.rich_text[1].plain_text) -- 113
    end -- 107
  } -- 107
  if _base_0.__index == nil then -- 107
    _base_0.__index = _base_0 -- 107
  end -- 113
  setmetatable(_base_0, _parent_0.__base) -- 107
  _class_0 = setmetatable({ -- 107
    __init = function(self, props) -- 108
      _class_0.__parent.__init(self, "bulleted_list_item", props) -- 109
      self.can_md = true -- 110
    end, -- 107
    __base = _base_0, -- 107
    __name = "BulletedListItem", -- 107
    __parent = _parent_0 -- 107
  }, { -- 107
    __index = function(cls, name) -- 107
      local val = rawget(_base_0, name) -- 107
      if val == nil then -- 107
        local parent = rawget(cls, "__parent") -- 107
        if parent then -- 107
          return parent[name] -- 107
        end -- 107
      else -- 107
        return val -- 107
      end -- 107
    end, -- 107
    __call = function(cls, ...) -- 107
      local _self_0 = setmetatable({ }, _base_0) -- 107
      cls.__init(_self_0, ...) -- 107
      return _self_0 -- 107
    end -- 107
  }) -- 107
  _base_0.__class = _class_0 -- 107
  if _parent_0.__inherited then -- 107
    _parent_0.__inherited(_parent_0, _class_0) -- 107
  end -- 107
  BulletedListItem = _class_0 -- 107
end -- 113
local NumberedListItem -- 115
do -- 115
  local _class_0 -- 115
  local _parent_0 = Block -- 115
  local _base_0 = { -- 115
    to_md = function(self) -- 120
      return "1. " .. tostring(table.concat((iter_rtext(self.content)))) -- 123
    end -- 115
  } -- 115
  if _base_0.__index == nil then -- 115
    _base_0.__index = _base_0 -- 115
  end -- 123
  setmetatable(_base_0, _parent_0.__base) -- 115
  _class_0 = setmetatable({ -- 115
    __init = function(self, props) -- 116
      _class_0.__parent.__init(self, "numbered_list_item", props) -- 117
      self.can_md = true -- 118
    end, -- 115
    __base = _base_0, -- 115
    __name = "NumberedListItem", -- 115
    __parent = _parent_0 -- 115
  }, { -- 115
    __index = function(cls, name) -- 115
      local val = rawget(_base_0, name) -- 115
      if val == nil then -- 115
        local parent = rawget(cls, "__parent") -- 115
        if parent then -- 115
          return parent[name] -- 115
        end -- 115
      else -- 115
        return val -- 115
      end -- 115
    end, -- 115
    __call = function(cls, ...) -- 115
      local _self_0 = setmetatable({ }, _base_0) -- 115
      cls.__init(_self_0, ...) -- 115
      return _self_0 -- 115
    end -- 115
  }) -- 115
  _base_0.__class = _class_0 -- 115
  if _parent_0.__inherited then -- 115
    _parent_0.__inherited(_parent_0, _class_0) -- 115
  end -- 115
  NumberedListItem = _class_0 -- 115
end -- 123
local ToDo -- 125
do -- 125
  local _class_0 -- 125
  local _parent_0 = Block -- 125
  local _base_0 = { -- 125
    to_md = function(self) -- 130
      local check = self.content.checked and "x" or " " -- 131
      return "- [" .. tostring(check) .. "] " .. tostring(table.concat((iter_rtext(self.content)))) -- 132
    end -- 125
  } -- 125
  if _base_0.__index == nil then -- 125
    _base_0.__index = _base_0 -- 125
  end -- 132
  setmetatable(_base_0, _parent_0.__base) -- 125
  _class_0 = setmetatable({ -- 125
    __init = function(self, props) -- 126
      _class_0.__parent.__init(self, "to_do", props) -- 127
      self.can_md = true -- 128
    end, -- 125
    __base = _base_0, -- 125
    __name = "ToDo", -- 125
    __parent = _parent_0 -- 125
  }, { -- 125
    __index = function(cls, name) -- 125
      local val = rawget(_base_0, name) -- 125
      if val == nil then -- 125
        local parent = rawget(cls, "__parent") -- 125
        if parent then -- 125
          return parent[name] -- 125
        end -- 125
      else -- 125
        return val -- 125
      end -- 125
    end, -- 125
    __call = function(cls, ...) -- 125
      local _self_0 = setmetatable({ }, _base_0) -- 125
      cls.__init(_self_0, ...) -- 125
      return _self_0 -- 125
    end -- 125
  }) -- 125
  _base_0.__class = _class_0 -- 125
  if _parent_0.__inherited then -- 125
    _parent_0.__inherited(_parent_0, _class_0) -- 125
  end -- 125
  ToDo = _class_0 -- 125
end -- 132
local Toggle -- 134
do -- 134
  local _class_0 -- 134
  local _parent_0 = Block -- 134
  local _base_0 = { -- 134
    to_md = function(self) -- 139
      return table.concat((iter_rtext(self.content))) -- 140
    end -- 134
  } -- 134
  if _base_0.__index == nil then -- 134
    _base_0.__index = _base_0 -- 134
  end -- 140
  setmetatable(_base_0, _parent_0.__base) -- 134
  _class_0 = setmetatable({ -- 134
    __init = function(self, props) -- 135
      _class_0.__parent.__init(self, "toggle", props) -- 136
      self.can_md = true -- 137
    end, -- 134
    __base = _base_0, -- 134
    __name = "Toggle", -- 134
    __parent = _parent_0 -- 134
  }, { -- 134
    __index = function(cls, name) -- 134
      local val = rawget(_base_0, name) -- 134
      if val == nil then -- 134
        local parent = rawget(cls, "__parent") -- 134
        if parent then -- 134
          return parent[name] -- 134
        end -- 134
      else -- 134
        return val -- 134
      end -- 134
    end, -- 134
    __call = function(cls, ...) -- 134
      local _self_0 = setmetatable({ }, _base_0) -- 134
      cls.__init(_self_0, ...) -- 134
      return _self_0 -- 134
    end -- 134
  }) -- 134
  _base_0.__class = _class_0 -- 134
  if _parent_0.__inherited then -- 134
    _parent_0.__inherited(_parent_0, _class_0) -- 134
  end -- 134
  Toggle = _class_0 -- 134
end -- 140
local ChildPage -- 142
do -- 142
  local _class_0 -- 142
  local _parent_0 = Block -- 142
  local _base_0 = { -- 142
    to_md = function(self) -- 147
      return "[" .. tostring(self.content.title) .. "](impulse://page/" .. tostring(self:get_id()) .. ")" -- 148
    end -- 142
  } -- 142
  if _base_0.__index == nil then -- 142
    _base_0.__index = _base_0 -- 142
  end -- 148
  setmetatable(_base_0, _parent_0.__base) -- 142
  _class_0 = setmetatable({ -- 142
    __init = function(self, props) -- 143
      _class_0.__parent.__init(self, "child_page", props) -- 144
      self.can_md = true -- 145
    end, -- 142
    __base = _base_0, -- 142
    __name = "ChildPage", -- 142
    __parent = _parent_0 -- 142
  }, { -- 142
    __index = function(cls, name) -- 142
      local val = rawget(_base_0, name) -- 142
      if val == nil then -- 142
        local parent = rawget(cls, "__parent") -- 142
        if parent then -- 142
          return parent[name] -- 142
        end -- 142
      else -- 142
        return val -- 142
      end -- 142
    end, -- 142
    __call = function(cls, ...) -- 142
      local _self_0 = setmetatable({ }, _base_0) -- 142
      cls.__init(_self_0, ...) -- 142
      return _self_0 -- 142
    end -- 142
  }) -- 142
  _base_0.__class = _class_0 -- 142
  if _parent_0.__inherited then -- 142
    _parent_0.__inherited(_parent_0, _class_0) -- 142
  end -- 142
  ChildPage = _class_0 -- 142
end -- 148
local ChildDatabase -- 150
do -- 150
  local _class_0 -- 150
  local _parent_0 = Block -- 150
  local _base_0 = { -- 150
    to_md = function(self) -- 155
      return "[" .. tostring(self.content.title) .. "](impulse://database/" .. tostring(self:get_id()) .. ")" -- 156
    end -- 150
  } -- 150
  if _base_0.__index == nil then -- 150
    _base_0.__index = _base_0 -- 150
  end -- 156
  setmetatable(_base_0, _parent_0.__base) -- 150
  _class_0 = setmetatable({ -- 150
    __init = function(self, props) -- 151
      _class_0.__parent.__init(self, "child_database", props) -- 152
      self.can_md = true -- 153
    end, -- 150
    __base = _base_0, -- 150
    __name = "ChildDatabase", -- 150
    __parent = _parent_0 -- 150
  }, { -- 150
    __index = function(cls, name) -- 150
      local val = rawget(_base_0, name) -- 150
      if val == nil then -- 150
        local parent = rawget(cls, "__parent") -- 150
        if parent then -- 150
          return parent[name] -- 150
        end -- 150
      else -- 150
        return val -- 150
      end -- 150
    end, -- 150
    __call = function(cls, ...) -- 150
      local _self_0 = setmetatable({ }, _base_0) -- 150
      cls.__init(_self_0, ...) -- 150
      return _self_0 -- 150
    end -- 150
  }) -- 150
  _base_0.__class = _class_0 -- 150
  if _parent_0.__inherited then -- 150
    _parent_0.__inherited(_parent_0, _class_0) -- 150
  end -- 150
  ChildDatabase = _class_0 -- 150
end -- 156
local Embed -- 158
do -- 158
  local _class_0 -- 158
  local _parent_0 = Block -- 158
  local _base_0 = { -- 158
    to_md = function(self) -- 163
      return "[embed-" .. tostring(self:get_id()) .. "](" .. tostring(self.content.url) .. ")" -- 164
    end -- 158
  } -- 158
  if _base_0.__index == nil then -- 158
    _base_0.__index = _base_0 -- 158
  end -- 164
  setmetatable(_base_0, _parent_0.__base) -- 158
  _class_0 = setmetatable({ -- 158
    __init = function(self, props) -- 159
      _class_0.__parent.__init(self, "embed", props) -- 160
      self.can_md = true -- 161
    end, -- 158
    __base = _base_0, -- 158
    __name = "Embed", -- 158
    __parent = _parent_0 -- 158
  }, { -- 158
    __index = function(cls, name) -- 158
      local val = rawget(_base_0, name) -- 158
      if val == nil then -- 158
        local parent = rawget(cls, "__parent") -- 158
        if parent then -- 158
          return parent[name] -- 158
        end -- 158
      else -- 158
        return val -- 158
      end -- 158
    end, -- 158
    __call = function(cls, ...) -- 158
      local _self_0 = setmetatable({ }, _base_0) -- 158
      cls.__init(_self_0, ...) -- 158
      return _self_0 -- 158
    end -- 158
  }) -- 158
  _base_0.__class = _class_0 -- 158
  if _parent_0.__inherited then -- 158
    _parent_0.__inherited(_parent_0, _class_0) -- 158
  end -- 158
  Embed = _class_0 -- 158
end -- 164
local Image -- 166
do -- 166
  local _class_0 -- 166
  local _parent_0 = Block -- 166
  local _base_0 = { -- 166
    to_md = function(self) -- 171
      local link -- 172
      if self.content.type == "external" then -- 172
        link = self.content.external.url -- 173
      else -- 175
        link = self.content.file.url -- 175
      end -- 172
      return "![image-" .. tostring(self:get_id()) .. "](" .. tostring(get_file_link(self.content)) .. ")" -- 177
    end -- 166
  } -- 166
  if _base_0.__index == nil then -- 166
    _base_0.__index = _base_0 -- 166
  end -- 177
  setmetatable(_base_0, _parent_0.__base) -- 166
  _class_0 = setmetatable({ -- 166
    __init = function(self, props) -- 167
      _class_0.__parent.__init(self, "image", props) -- 168
      self.can_md = true -- 169
    end, -- 166
    __base = _base_0, -- 166
    __name = "Image", -- 166
    __parent = _parent_0 -- 166
  }, { -- 166
    __index = function(cls, name) -- 166
      local val = rawget(_base_0, name) -- 166
      if val == nil then -- 166
        local parent = rawget(cls, "__parent") -- 166
        if parent then -- 166
          return parent[name] -- 166
        end -- 166
      else -- 166
        return val -- 166
      end -- 166
    end, -- 166
    __call = function(cls, ...) -- 166
      local _self_0 = setmetatable({ }, _base_0) -- 166
      cls.__init(_self_0, ...) -- 166
      return _self_0 -- 166
    end -- 166
  }) -- 166
  _base_0.__class = _class_0 -- 166
  if _parent_0.__inherited then -- 166
    _parent_0.__inherited(_parent_0, _class_0) -- 166
  end -- 166
  Image = _class_0 -- 166
end -- 177
local Video -- 179
do -- 179
  local _class_0 -- 179
  local _parent_0 = Block -- 179
  local _base_0 = { -- 179
    to_md = function(self) -- 184
      return "[video-" .. tostring(self:get_id()) .. "](" .. tostring(get_file_link(self.content)) .. ")" -- 185
    end -- 179
  } -- 179
  if _base_0.__index == nil then -- 179
    _base_0.__index = _base_0 -- 179
  end -- 185
  setmetatable(_base_0, _parent_0.__base) -- 179
  _class_0 = setmetatable({ -- 179
    __init = function(self, props) -- 180
      _class_0.__parent.__init(self, "video", props) -- 181
      self.can_md = true -- 182
    end, -- 179
    __base = _base_0, -- 179
    __name = "Video", -- 179
    __parent = _parent_0 -- 179
  }, { -- 179
    __index = function(cls, name) -- 179
      local val = rawget(_base_0, name) -- 179
      if val == nil then -- 179
        local parent = rawget(cls, "__parent") -- 179
        if parent then -- 179
          return parent[name] -- 179
        end -- 179
      else -- 179
        return val -- 179
      end -- 179
    end, -- 179
    __call = function(cls, ...) -- 179
      local _self_0 = setmetatable({ }, _base_0) -- 179
      cls.__init(_self_0, ...) -- 179
      return _self_0 -- 179
    end -- 179
  }) -- 179
  _base_0.__class = _class_0 -- 179
  if _parent_0.__inherited then -- 179
    _parent_0.__inherited(_parent_0, _class_0) -- 179
  end -- 179
  Video = _class_0 -- 179
end -- 185
local File -- 187
do -- 187
  local _class_0 -- 187
  local _parent_0 = Block -- 187
  local _base_0 = { -- 187
    to_md = function(self) -- 192
      return "[file-" .. tostring(self:get_id()) .. "](" .. tostring(get_file_link(self.content)) .. ")" -- 193
    end -- 187
  } -- 187
  if _base_0.__index == nil then -- 187
    _base_0.__index = _base_0 -- 187
  end -- 193
  setmetatable(_base_0, _parent_0.__base) -- 187
  _class_0 = setmetatable({ -- 187
    __init = function(self, props) -- 188
      _class_0.__parent.__init(self, "file", props) -- 189
      self.can_md = true -- 190
    end, -- 187
    __base = _base_0, -- 187
    __name = "File", -- 187
    __parent = _parent_0 -- 187
  }, { -- 187
    __index = function(cls, name) -- 187
      local val = rawget(_base_0, name) -- 187
      if val == nil then -- 187
        local parent = rawget(cls, "__parent") -- 187
        if parent then -- 187
          return parent[name] -- 187
        end -- 187
      else -- 187
        return val -- 187
      end -- 187
    end, -- 187
    __call = function(cls, ...) -- 187
      local _self_0 = setmetatable({ }, _base_0) -- 187
      cls.__init(_self_0, ...) -- 187
      return _self_0 -- 187
    end -- 187
  }) -- 187
  _base_0.__class = _class_0 -- 187
  if _parent_0.__inherited then -- 187
    _parent_0.__inherited(_parent_0, _class_0) -- 187
  end -- 187
  File = _class_0 -- 187
end -- 193
local Pdf -- 195
do -- 195
  local _class_0 -- 195
  local _parent_0 = Block -- 195
  local _base_0 = { -- 195
    to_md = function(self) -- 200
      return "[pdf-" .. tostring(self:get_id()) .. "](" .. tostring(get_file_link(self.content)) .. ")" -- 201
    end -- 195
  } -- 195
  if _base_0.__index == nil then -- 195
    _base_0.__index = _base_0 -- 195
  end -- 201
  setmetatable(_base_0, _parent_0.__base) -- 195
  _class_0 = setmetatable({ -- 195
    __init = function(self, props) -- 196
      _class_0.__parent.__init(self, "pdf", props) -- 197
      self.can_md = true -- 198
    end, -- 195
    __base = _base_0, -- 195
    __name = "Pdf", -- 195
    __parent = _parent_0 -- 195
  }, { -- 195
    __index = function(cls, name) -- 195
      local val = rawget(_base_0, name) -- 195
      if val == nil then -- 195
        local parent = rawget(cls, "__parent") -- 195
        if parent then -- 195
          return parent[name] -- 195
        end -- 195
      else -- 195
        return val -- 195
      end -- 195
    end, -- 195
    __call = function(cls, ...) -- 195
      local _self_0 = setmetatable({ }, _base_0) -- 195
      cls.__init(_self_0, ...) -- 195
      return _self_0 -- 195
    end -- 195
  }) -- 195
  _base_0.__class = _class_0 -- 195
  if _parent_0.__inherited then -- 195
    _parent_0.__inherited(_parent_0, _class_0) -- 195
  end -- 195
  Pdf = _class_0 -- 195
end -- 201
local Bookmark -- 203
do -- 203
  local _class_0 -- 203
  local _parent_0 = Block -- 203
  local _base_0 = { -- 203
    to_md = function(self) -- 208
      return "[bookmark-" .. tostring(self:get_id()) .. "](" .. tostring(self.content.url) .. ")" -- 209
    end -- 203
  } -- 203
  if _base_0.__index == nil then -- 203
    _base_0.__index = _base_0 -- 203
  end -- 209
  setmetatable(_base_0, _parent_0.__base) -- 203
  _class_0 = setmetatable({ -- 203
    __init = function(self, props) -- 204
      _class_0.__parent.__init(self, "bookmark", props) -- 205
      self.can_md = true -- 206
    end, -- 203
    __base = _base_0, -- 203
    __name = "Bookmark", -- 203
    __parent = _parent_0 -- 203
  }, { -- 203
    __index = function(cls, name) -- 203
      local val = rawget(_base_0, name) -- 203
      if val == nil then -- 203
        local parent = rawget(cls, "__parent") -- 203
        if parent then -- 203
          return parent[name] -- 203
        end -- 203
      else -- 203
        return val -- 203
      end -- 203
    end, -- 203
    __call = function(cls, ...) -- 203
      local _self_0 = setmetatable({ }, _base_0) -- 203
      cls.__init(_self_0, ...) -- 203
      return _self_0 -- 203
    end -- 203
  }) -- 203
  _base_0.__class = _class_0 -- 203
  if _parent_0.__inherited then -- 203
    _parent_0.__inherited(_parent_0, _class_0) -- 203
  end -- 203
  Bookmark = _class_0 -- 203
end -- 209
local Callout -- 211
do -- 211
  local _class_0 -- 211
  local _parent_0 = Block -- 211
  local _base_0 = { -- 211
    to_md = function(self) -- 216
      return "> " .. tostring(inspect((iter_rtext(self.content)))) -- 217
    end -- 211
  } -- 211
  if _base_0.__index == nil then -- 211
    _base_0.__index = _base_0 -- 211
  end -- 217
  setmetatable(_base_0, _parent_0.__base) -- 211
  _class_0 = setmetatable({ -- 211
    __init = function(self, props) -- 212
      _class_0.__parent.__init(self, "callout", props) -- 213
      self.can_md = true -- 214
    end, -- 211
    __base = _base_0, -- 211
    __name = "Callout", -- 211
    __parent = _parent_0 -- 211
  }, { -- 211
    __index = function(cls, name) -- 211
      local val = rawget(_base_0, name) -- 211
      if val == nil then -- 211
        local parent = rawget(cls, "__parent") -- 211
        if parent then -- 211
          return parent[name] -- 211
        end -- 211
      else -- 211
        return val -- 211
      end -- 211
    end, -- 211
    __call = function(cls, ...) -- 211
      local _self_0 = setmetatable({ }, _base_0) -- 211
      cls.__init(_self_0, ...) -- 211
      return _self_0 -- 211
    end -- 211
  }) -- 211
  _base_0.__class = _class_0 -- 211
  if _parent_0.__inherited then -- 211
    _parent_0.__inherited(_parent_0, _class_0) -- 211
  end -- 211
  Callout = _class_0 -- 211
end -- 217
local Quote -- 219
do -- 219
  local _class_0 -- 219
  local _parent_0 = Block -- 219
  local _base_0 = { -- 219
    to_md = function(self) -- 224
      return "> " .. tostring(table.concat((iter_rtext(self.content)))) -- 225
    end -- 219
  } -- 219
  if _base_0.__index == nil then -- 219
    _base_0.__index = _base_0 -- 219
  end -- 225
  setmetatable(_base_0, _parent_0.__base) -- 219
  _class_0 = setmetatable({ -- 219
    __init = function(self, props) -- 220
      _class_0.__parent.__init(self, "quote", props) -- 221
      self.can_md = true -- 222
    end, -- 219
    __base = _base_0, -- 219
    __name = "Quote", -- 219
    __parent = _parent_0 -- 219
  }, { -- 219
    __index = function(cls, name) -- 219
      local val = rawget(_base_0, name) -- 219
      if val == nil then -- 219
        local parent = rawget(cls, "__parent") -- 219
        if parent then -- 219
          return parent[name] -- 219
        end -- 219
      else -- 219
        return val -- 219
      end -- 219
    end, -- 219
    __call = function(cls, ...) -- 219
      local _self_0 = setmetatable({ }, _base_0) -- 219
      cls.__init(_self_0, ...) -- 219
      return _self_0 -- 219
    end -- 219
  }) -- 219
  _base_0.__class = _class_0 -- 219
  if _parent_0.__inherited then -- 219
    _parent_0.__inherited(_parent_0, _class_0) -- 219
  end -- 219
  Quote = _class_0 -- 219
end -- 225
local Equation -- 227
do -- 227
  local _class_0 -- 227
  local _parent_0 = Block -- 227
  local _base_0 = { -- 227
    to_md = function(self) -- 232
      return { -- 234
        "```impulse://equation/" .. tostring(self:get_id()), -- 234
        tostring(self.content.expression), -- 235
        "```" -- 236
      } -- 237
    end -- 227
  } -- 227
  if _base_0.__index == nil then -- 227
    _base_0.__index = _base_0 -- 227
  end -- 237
  setmetatable(_base_0, _parent_0.__base) -- 227
  _class_0 = setmetatable({ -- 227
    __init = function(self, props) -- 228
      _class_0.__parent.__init(self, "equation", props) -- 229
      self.can_md = true -- 230
    end, -- 227
    __base = _base_0, -- 227
    __name = "Equation", -- 227
    __parent = _parent_0 -- 227
  }, { -- 227
    __index = function(cls, name) -- 227
      local val = rawget(_base_0, name) -- 227
      if val == nil then -- 227
        local parent = rawget(cls, "__parent") -- 227
        if parent then -- 227
          return parent[name] -- 227
        end -- 227
      else -- 227
        return val -- 227
      end -- 227
    end, -- 227
    __call = function(cls, ...) -- 227
      local _self_0 = setmetatable({ }, _base_0) -- 227
      cls.__init(_self_0, ...) -- 227
      return _self_0 -- 227
    end -- 227
  }) -- 227
  _base_0.__class = _class_0 -- 227
  if _parent_0.__inherited then -- 227
    _parent_0.__inherited(_parent_0, _class_0) -- 227
  end -- 227
  Equation = _class_0 -- 227
end -- 237
local Divider -- 239
do -- 239
  local _class_0 -- 239
  local _parent_0 = Block -- 239
  local _base_0 = { -- 239
    to_md = function(self) -- 244
      return "-------" -- 245
    end -- 239
  } -- 239
  if _base_0.__index == nil then -- 239
    _base_0.__index = _base_0 -- 239
  end -- 245
  setmetatable(_base_0, _parent_0.__base) -- 239
  _class_0 = setmetatable({ -- 239
    __init = function(self, props) -- 240
      _class_0.__parent.__init(self, "divider", props) -- 241
      self.can_md = true -- 242
    end, -- 239
    __base = _base_0, -- 239
    __name = "Divider", -- 239
    __parent = _parent_0 -- 239
  }, { -- 239
    __index = function(cls, name) -- 239
      local val = rawget(_base_0, name) -- 239
      if val == nil then -- 239
        local parent = rawget(cls, "__parent") -- 239
        if parent then -- 239
          return parent[name] -- 239
        end -- 239
      else -- 239
        return val -- 239
      end -- 239
    end, -- 239
    __call = function(cls, ...) -- 239
      local _self_0 = setmetatable({ }, _base_0) -- 239
      cls.__init(_self_0, ...) -- 239
      return _self_0 -- 239
    end -- 239
  }) -- 239
  _base_0.__class = _class_0 -- 239
  if _parent_0.__inherited then -- 239
    _parent_0.__inherited(_parent_0, _class_0) -- 239
  end -- 239
  Divider = _class_0 -- 239
end -- 245
local TableOfContents -- 247
do -- 247
  local _class_0 -- 247
  local _parent_0 = Block -- 247
  local _base_0 = { -- 247
    to_md = function(self) -- 252
      return nil -- 256
    end -- 247
  } -- 247
  if _base_0.__index == nil then -- 247
    _base_0.__index = _base_0 -- 247
  end -- 256
  setmetatable(_base_0, _parent_0.__base) -- 247
  _class_0 = setmetatable({ -- 247
    __init = function(self, props) -- 248
      _class_0.__parent.__init(self, "table_of_contents", props) -- 249
      self.can_md = true -- 250
    end, -- 247
    __base = _base_0, -- 247
    __name = "TableOfContents", -- 247
    __parent = _parent_0 -- 247
  }, { -- 247
    __index = function(cls, name) -- 247
      local val = rawget(_base_0, name) -- 247
      if val == nil then -- 247
        local parent = rawget(cls, "__parent") -- 247
        if parent then -- 247
          return parent[name] -- 247
        end -- 247
      else -- 247
        return val -- 247
      end -- 247
    end, -- 247
    __call = function(cls, ...) -- 247
      local _self_0 = setmetatable({ }, _base_0) -- 247
      cls.__init(_self_0, ...) -- 247
      return _self_0 -- 247
    end -- 247
  }) -- 247
  _base_0.__class = _class_0 -- 247
  if _parent_0.__inherited then -- 247
    _parent_0.__inherited(_parent_0, _class_0) -- 247
  end -- 247
  TableOfContents = _class_0 -- 247
end -- 256
local Column -- 258
do -- 258
  local _class_0 -- 258
  local _parent_0 = Block -- 258
  local _base_0 = { -- 258
    to_md = function(self) -- 263
      return nil -- 266
    end -- 258
  } -- 258
  if _base_0.__index == nil then -- 258
    _base_0.__index = _base_0 -- 258
  end -- 266
  setmetatable(_base_0, _parent_0.__base) -- 258
  _class_0 = setmetatable({ -- 258
    __init = function(self, props) -- 259
      _class_0.__parent.__init(self, "column", props) -- 260
      self.can_md = true -- 261
    end, -- 258
    __base = _base_0, -- 258
    __name = "Column", -- 258
    __parent = _parent_0 -- 258
  }, { -- 258
    __index = function(cls, name) -- 258
      local val = rawget(_base_0, name) -- 258
      if val == nil then -- 258
        local parent = rawget(cls, "__parent") -- 258
        if parent then -- 258
          return parent[name] -- 258
        end -- 258
      else -- 258
        return val -- 258
      end -- 258
    end, -- 258
    __call = function(cls, ...) -- 258
      local _self_0 = setmetatable({ }, _base_0) -- 258
      cls.__init(_self_0, ...) -- 258
      return _self_0 -- 258
    end -- 258
  }) -- 258
  _base_0.__class = _class_0 -- 258
  if _parent_0.__inherited then -- 258
    _parent_0.__inherited(_parent_0, _class_0) -- 258
  end -- 258
  Column = _class_0 -- 258
end -- 266
local ColumnList -- 268
do -- 268
  local _class_0 -- 268
  local _parent_0 = Block -- 268
  local _base_0 = { -- 268
    to_md = function(self) -- 273
      return nil -- 276
    end -- 268
  } -- 268
  if _base_0.__index == nil then -- 268
    _base_0.__index = _base_0 -- 268
  end -- 276
  setmetatable(_base_0, _parent_0.__base) -- 268
  _class_0 = setmetatable({ -- 268
    __init = function(self, props) -- 269
      _class_0.__parent.__init(self, "column_list", props) -- 270
      self.can_md = true -- 271
    end, -- 268
    __base = _base_0, -- 268
    __name = "ColumnList", -- 268
    __parent = _parent_0 -- 268
  }, { -- 268
    __index = function(cls, name) -- 268
      local val = rawget(_base_0, name) -- 268
      if val == nil then -- 268
        local parent = rawget(cls, "__parent") -- 268
        if parent then -- 268
          return parent[name] -- 268
        end -- 268
      else -- 268
        return val -- 268
      end -- 268
    end, -- 268
    __call = function(cls, ...) -- 268
      local _self_0 = setmetatable({ }, _base_0) -- 268
      cls.__init(_self_0, ...) -- 268
      return _self_0 -- 268
    end -- 268
  }) -- 268
  _base_0.__class = _class_0 -- 268
  if _parent_0.__inherited then -- 268
    _parent_0.__inherited(_parent_0, _class_0) -- 268
  end -- 268
  ColumnList = _class_0 -- 268
end -- 276
local LinkPreview -- 278
do -- 278
  local _class_0 -- 278
  local _parent_0 = Block -- 278
  local _base_0 = { -- 278
    to_md = function(self) -- 283
      return "[linkpreview-" .. tostring(self:get_id()) .. "](" .. tostring(self.content.url) .. ") ++ " .. tostring(inspect(self.properties)) -- 284
    end -- 278
  } -- 278
  if _base_0.__index == nil then -- 278
    _base_0.__index = _base_0 -- 278
  end -- 284
  setmetatable(_base_0, _parent_0.__base) -- 278
  _class_0 = setmetatable({ -- 278
    __init = function(self, props) -- 279
      _class_0.__parent.__init(self, "link_preview", props) -- 280
      self.can_md = true -- 281
    end, -- 278
    __base = _base_0, -- 278
    __name = "LinkPreview", -- 278
    __parent = _parent_0 -- 278
  }, { -- 278
    __index = function(cls, name) -- 278
      local val = rawget(_base_0, name) -- 278
      if val == nil then -- 278
        local parent = rawget(cls, "__parent") -- 278
        if parent then -- 278
          return parent[name] -- 278
        end -- 278
      else -- 278
        return val -- 278
      end -- 278
    end, -- 278
    __call = function(cls, ...) -- 278
      local _self_0 = setmetatable({ }, _base_0) -- 278
      cls.__init(_self_0, ...) -- 278
      return _self_0 -- 278
    end -- 278
  }) -- 278
  _base_0.__class = _class_0 -- 278
  if _parent_0.__inherited then -- 278
    _parent_0.__inherited(_parent_0, _class_0) -- 278
  end -- 278
  LinkPreview = _class_0 -- 278
end -- 284
local SyncedBlock -- 286
do -- 286
  local _class_0 -- 286
  local _parent_0 = Block -- 286
  local _base_0 = { -- 286
    to_md = function(self) -- 291
      return "[start-synced-block](impulse://block/" .. tostring(self:get_id()) .. ")" -- 292
    end -- 286
  } -- 286
  if _base_0.__index == nil then -- 286
    _base_0.__index = _base_0 -- 286
  end -- 292
  setmetatable(_base_0, _parent_0.__base) -- 286
  _class_0 = setmetatable({ -- 286
    __init = function(self, props) -- 287
      _class_0.__parent.__init(self, "synced_block", props) -- 288
      self.can_md = true -- 289
    end, -- 286
    __base = _base_0, -- 286
    __name = "SyncedBlock", -- 286
    __parent = _parent_0 -- 286
  }, { -- 286
    __index = function(cls, name) -- 286
      local val = rawget(_base_0, name) -- 286
      if val == nil then -- 286
        local parent = rawget(cls, "__parent") -- 286
        if parent then -- 286
          return parent[name] -- 286
        end -- 286
      else -- 286
        return val -- 286
      end -- 286
    end, -- 286
    __call = function(cls, ...) -- 286
      local _self_0 = setmetatable({ }, _base_0) -- 286
      cls.__init(_self_0, ...) -- 286
      return _self_0 -- 286
    end -- 286
  }) -- 286
  _base_0.__class = _class_0 -- 286
  if _parent_0.__inherited then -- 286
    _parent_0.__inherited(_parent_0, _class_0) -- 286
  end -- 286
  SyncedBlock = _class_0 -- 286
end -- 292
local Template -- 294
do -- 294
  local _class_0 -- 294
  local _parent_0 = Block -- 294
  local _base_0 = { -- 294
    to_md = function(self) -- 299
      return "[template-" .. tostring(self:get_id()) .. "](impulse://template/" .. tostring(self:get_id()) .. ") ++ " .. tostring(inspect(self.content)) -- 300
    end -- 294
  } -- 294
  if _base_0.__index == nil then -- 294
    _base_0.__index = _base_0 -- 294
  end -- 300
  setmetatable(_base_0, _parent_0.__base) -- 294
  _class_0 = setmetatable({ -- 294
    __init = function(self, props) -- 295
      _class_0.__parent.__init(self, "template", props) -- 296
      self.can_md = true -- 297
    end, -- 294
    __base = _base_0, -- 294
    __name = "Template", -- 294
    __parent = _parent_0 -- 294
  }, { -- 294
    __index = function(cls, name) -- 294
      local val = rawget(_base_0, name) -- 294
      if val == nil then -- 294
        local parent = rawget(cls, "__parent") -- 294
        if parent then -- 294
          return parent[name] -- 294
        end -- 294
      else -- 294
        return val -- 294
      end -- 294
    end, -- 294
    __call = function(cls, ...) -- 294
      local _self_0 = setmetatable({ }, _base_0) -- 294
      cls.__init(_self_0, ...) -- 294
      return _self_0 -- 294
    end -- 294
  }) -- 294
  _base_0.__class = _class_0 -- 294
  if _parent_0.__inherited then -- 294
    _parent_0.__inherited(_parent_0, _class_0) -- 294
  end -- 294
  Template = _class_0 -- 294
end -- 300
local LinkToPage -- 302
do -- 302
  local _class_0 -- 302
  local _parent_0 = Block -- 302
  local _base_0 = { -- 302
    to_md = function(self) -- 307
      return "[linktopage-" .. tostring(self:get_id()) .. "](" .. tostring(inspect(self.content)) .. ")" -- 308
    end -- 302
  } -- 302
  if _base_0.__index == nil then -- 302
    _base_0.__index = _base_0 -- 302
  end -- 308
  setmetatable(_base_0, _parent_0.__base) -- 302
  _class_0 = setmetatable({ -- 302
    __init = function(self, props) -- 303
      _class_0.__parent.__init(self, "link_to_page", props) -- 304
      self.can_md = true -- 305
    end, -- 302
    __base = _base_0, -- 302
    __name = "LinkToPage", -- 302
    __parent = _parent_0 -- 302
  }, { -- 302
    __index = function(cls, name) -- 302
      local val = rawget(_base_0, name) -- 302
      if val == nil then -- 302
        local parent = rawget(cls, "__parent") -- 302
        if parent then -- 302
          return parent[name] -- 302
        end -- 302
      else -- 302
        return val -- 302
      end -- 302
    end, -- 302
    __call = function(cls, ...) -- 302
      local _self_0 = setmetatable({ }, _base_0) -- 302
      cls.__init(_self_0, ...) -- 302
      return _self_0 -- 302
    end -- 302
  }) -- 302
  _base_0.__class = _class_0 -- 302
  if _parent_0.__inherited then -- 302
    _parent_0.__inherited(_parent_0, _class_0) -- 302
  end -- 302
  LinkToPage = _class_0 -- 302
end -- 308
local Table -- 310
do -- 310
  local _class_0 -- 310
  local _parent_0 = Block -- 310
  local _base_0 = { -- 310
    to_md = function(self) -- 315
      return nil -- 315
    end -- 310
  } -- 310
  if _base_0.__index == nil then -- 310
    _base_0.__index = _base_0 -- 310
  end -- 315
  setmetatable(_base_0, _parent_0.__base) -- 310
  _class_0 = setmetatable({ -- 310
    __init = function(self, props) -- 311
      _class_0.__parent.__init(self, "table", props) -- 312
      self.can_md = true -- 313
    end, -- 310
    __base = _base_0, -- 310
    __name = "Table", -- 310
    __parent = _parent_0 -- 310
  }, { -- 310
    __index = function(cls, name) -- 310
      local val = rawget(_base_0, name) -- 310
      if val == nil then -- 310
        local parent = rawget(cls, "__parent") -- 310
        if parent then -- 310
          return parent[name] -- 310
        end -- 310
      else -- 310
        return val -- 310
      end -- 310
    end, -- 310
    __call = function(cls, ...) -- 310
      local _self_0 = setmetatable({ }, _base_0) -- 310
      cls.__init(_self_0, ...) -- 310
      return _self_0 -- 310
    end -- 310
  }) -- 310
  _base_0.__class = _class_0 -- 310
  if _parent_0.__inherited then -- 310
    _parent_0.__inherited(_parent_0, _class_0) -- 310
  end -- 310
  Table = _class_0 -- 310
end -- 315
local TableRow -- 317
do -- 317
  local _class_0 -- 317
  local _parent_0 = Block -- 317
  local _base_0 = { -- 317
    to_md = function(self) -- 322
      local cells = self.content.cells -- 323
      local r = { } -- 325
      for _index_0 = 1, #cells do -- 326
        local v = cells[_index_0] -- 326
        for _index_1 = 1, #v do -- 327
          local vv = v[_index_1] -- 327
          r[#r + 1] = vv.plain_text -- 328
        end -- 328
      end -- 328
      return "| " .. tostring((table.concat(r, " | "))) .. " |" -- 330
    end -- 317
  } -- 317
  if _base_0.__index == nil then -- 317
    _base_0.__index = _base_0 -- 317
  end -- 330
  setmetatable(_base_0, _parent_0.__base) -- 317
  _class_0 = setmetatable({ -- 317
    __init = function(self, props) -- 318
      _class_0.__parent.__init(self, "table_row", props) -- 319
      self.can_md = true -- 320
    end, -- 317
    __base = _base_0, -- 317
    __name = "TableRow", -- 317
    __parent = _parent_0 -- 317
  }, { -- 317
    __index = function(cls, name) -- 317
      local val = rawget(_base_0, name) -- 317
      if val == nil then -- 317
        local parent = rawget(cls, "__parent") -- 317
        if parent then -- 317
          return parent[name] -- 317
        end -- 317
      else -- 317
        return val -- 317
      end -- 317
    end, -- 317
    __call = function(cls, ...) -- 317
      local _self_0 = setmetatable({ }, _base_0) -- 317
      cls.__init(_self_0, ...) -- 317
      return _self_0 -- 317
    end -- 317
  }) -- 317
  _base_0.__class = _class_0 -- 317
  if _parent_0.__inherited then -- 317
    _parent_0.__inherited(_parent_0, _class_0) -- 317
  end -- 317
  TableRow = _class_0 -- 317
end -- 330
local Code -- 332
do -- 332
  local _class_0 -- 332
  local _parent_0 = Block -- 332
  local _base_0 = { -- 332
    to_md = function(self) -- 337
      local _tab_0 = { -- 339
        "```" .. tostring(self.content.language) -- 339
      } -- 340
      local _obj_0 = iter_rtext(self.content) -- 340
      local _idx_0 = 1 -- 340
      for _key_0, _value_0 in pairs(_obj_0) do -- 340
        if _idx_0 == _key_0 then -- 340
          _tab_0[#_tab_0 + 1] = _value_0 -- 340
          _idx_0 = _idx_0 + 1 -- 340
        else -- 340
          _tab_0[_key_0] = _value_0 -- 340
        end -- 340
      end -- 340
      _tab_0[#_tab_0 + 1] = "```" -- 341
      return _tab_0 -- 339
    end -- 332
  } -- 332
  if _base_0.__index == nil then -- 332
    _base_0.__index = _base_0 -- 332
  end -- 342
  setmetatable(_base_0, _parent_0.__base) -- 332
  _class_0 = setmetatable({ -- 332
    __init = function(self, props) -- 333
      _class_0.__parent.__init(self, "code", props) -- 334
      self.can_md = true -- 335
    end, -- 332
    __base = _base_0, -- 332
    __name = "Code", -- 332
    __parent = _parent_0 -- 332
  }, { -- 332
    __index = function(cls, name) -- 332
      local val = rawget(_base_0, name) -- 332
      if val == nil then -- 332
        local parent = rawget(cls, "__parent") -- 332
        if parent then -- 332
          return parent[name] -- 332
        end -- 332
      else -- 332
        return val -- 332
      end -- 332
    end, -- 332
    __call = function(cls, ...) -- 332
      local _self_0 = setmetatable({ }, _base_0) -- 332
      cls.__init(_self_0, ...) -- 332
      return _self_0 -- 332
    end -- 332
  }) -- 332
  _base_0.__class = _class_0 -- 332
  if _parent_0.__inherited then -- 332
    _parent_0.__inherited(_parent_0, _class_0) -- 332
  end -- 332
  Code = _class_0 -- 332
end -- 342
local types = { -- 345
  paragraph = Paragraph, -- 345
  heading_1 = Heading1, -- 346
  heading_2 = Heading2, -- 347
  heading_3 = Heading3, -- 348
  bulleted_list_item = BulletedListItem, -- 349
  numbered_list_item = NumberedListItem, -- 350
  to_do = ToDo, -- 351
  toggle = Toggle, -- 352
  code = Code, -- 353
  child_page = ChildPage, -- 354
  child_database = ChildDatabase, -- 355
  embed = Embed, -- 356
  image = Image, -- 357
  video = Video, -- 358
  file = File, -- 359
  pdf = Pdf, -- 360
  bookmark = Bookmark, -- 361
  callout = Callout, -- 362
  quote = Quote, -- 363
  equation = Equation, -- 364
  divider = Divider, -- 365
  table_of_contents = TableOfContents, -- 366
  column = Column, -- 367
  column_list = ColumnList, -- 368
  link_preview = LinkPreview, -- 369
  synced_block = SyncedBlock, -- 370
  template = Template, -- 371
  link_to_page = LinkToPage, -- 372
  table = Table, -- 373
  table_row = TableRow, -- 374
  unsupported = Unsupported -- 375
} -- 344
_module_0 = { -- 378
  types = types, -- 378
  to_type = function(typ, props) -- 379
    if not types[typ] then -- 380
      error("unsupported block type " .. tostring(typ)) -- 381
    end -- 380
    return types[typ](props) -- 383
  end -- 379
} -- 377
return _module_0 -- 384
