-- [yue]: ./impulse/buffer.yue
local _module_0 = nil -- 1
local Buffer -- 1
do -- 1
  local _class_0 -- 1
  local _base_0 = { -- 1
    get_buf = function(self) -- 13
      return self.buf -- 13
    end, -- 18
    set_content = function(self, content) -- 18
      if (type(content)) == "string" then -- 19
        local oc = content -- 20
        content = { } -- 21
        for v in oc:gmatch("^[\n]+") do -- 22
          content[#content + 1] = v -- 23
        end -- 23
      end -- 19
      return vim.api.nvim_buf_set_lines(self.buf, 0, -1, true, content) -- 25
    end, -- 29
    empty = function(self) -- 29
      return (vim.api.nvim_buf_line_count(self.buf)) <= 1 -- 29
    end, -- 32
    focus = function(self) -- 32
      return vim.api.nvim_set_current_buf(self.buf) -- 33
    end, -- 36
    delete = function(self, force) -- 36
      if force == nil then -- 36
        force = true -- 36
      end -- 36
      return vim.api.nvim_buf_delete(self.buf, { -- 37
        force = force -- 37
      }) -- 37
    end, -- 40
    set = function(self, name, val) -- 40
      return vim.api.nvim_buf_set_option(self.buf, name, val) -- 41
    end, -- 44
    set_name = function(self, name) -- 44
      if name == nil then -- 44
        name = "(no name)" -- 44
      end -- 44
      return vim.api.nvim_buf_set_name(self.buf, "impulse://" .. tostring(name)) -- 45
    end -- 1
  } -- 1
  if _base_0.__index == nil then -- 1
    _base_0.__index = _base_0 -- 1
  end -- 45
  _class_0 = setmetatable({ -- 1
    __init = function(self) -- 3
      vim.cmd([[ enew ]]) -- 4
      self.buf = vim.api.nvim_get_current_buf() -- 5
      vim.cmd([[ setlocal filetype=markdown ]]) -- 7
      self:set("buftype", "nofile") -- 8
      return self:set("swapfile", false) -- 10
    end, -- 1
    __base = _base_0, -- 1
    __name = "Buffer" -- 1
  }, { -- 1
    __index = _base_0, -- 1
    __call = function(cls, ...) -- 1
      local _self_0 = setmetatable({ }, _base_0) -- 1
      cls.__init(_self_0, ...) -- 1
      return _self_0 -- 1
    end -- 1
  }) -- 1
  _base_0.__class = _class_0 -- 1
  Buffer = _class_0 -- 1
end -- 45
_module_0 = Buffer -- 47
return _module_0 -- 47
