-- [yue]: ./impulse/api.yue
local _module_0 = nil -- 1
local curl = require("plenary.curl") -- 1
local Notion -- 3
do -- 3
  local _class_0 -- 3
  local _base_0 = { -- 3
    _request = function(self, api, method, body, timeout) -- 11
      if method == nil then -- 11
        method = "GET" -- 11
      end -- 11
      if body == nil then -- 11
        body = nil -- 11
      end -- 11
      if timeout == nil then -- 11
        timeout = self.__class.timeout -- 11
      end -- 11
      local opt = { -- 13
        url = tostring(self.__class.base_url) .. "/" .. tostring(api), -- 13
        accept = "application/json", -- 14
        method = method, -- 15
        headers = { -- 17
          ["user-agent"] = "impulse.nvim-0.1-alpha", -- 17
          ["x-req-by"] = "impulse.nvim", -- 18
          ["content-type"] = "application/json", -- 19
          authorization = "Bearer " .. tostring(self.api_key), -- 20
          ["notion-version"] = "2022-02-22" -- 21
        } -- 16
      } -- 12
      if body then -- 23
        opt.body = vim.json.encode(body) -- 24
      end -- 23
      local resp = curl.request(opt) -- 26
      if not (resp.status == 200) then -- 27
        return error("unable to make request to " .. tostring(api)) -- 28
      end -- 27
      return vim.json.decode(resp.body) -- 30
    end, -- 34
    get_page = function(self, id) -- 34
      return self:_request("v1/pages/" .. tostring(id)) -- 35
    end, -- 38
    update_page = function(self, id, data) -- 38
      if data == nil then -- 38
        data = nil -- 38
      end -- 38
      return self:_request("v1/pages/" .. tostring(id), "PATCH", data) -- 39
    end, -- 42
    get_block = function(self, id) -- 42
      return self:_request("v1/blocks/" .. tostring(id)) -- 43
    end, -- 47
    get_blocks = function(self, parent_id, start_cursor, page_size) -- 47
      if start_cursor == nil then -- 47
        start_cursor = 0 -- 47
      end -- 47
      if page_size == nil then -- 47
        page_size = self.__class.page_size -- 47
      end -- 47
      local qs = "page_size=" .. tostring(page_size) -- 48
      if start_cursor > 0 then -- 49
        qs = qs .. "&start_cursor=" .. tostring(start_cursor) -- 49
      end -- 49
      return self:_request("v1/blocks/" .. tostring(parent_id) .. "/children?" .. tostring(qs)) -- 51
    end, -- 54
    search = function(self, query, filter) -- 54
      if query == nil then -- 54
        query = "" -- 54
      end -- 54
      if filter == nil then -- 54
        filter = nil -- 54
      end -- 54
      if not filter then -- 55
        filter = { -- 57
          property = "object", -- 57
          value = "page" -- 58
        } -- 56
      end -- 55
      return self:_request("v1/search", "POST", { -- 61
        query = query, -- 61
        filter = filter -- 61
      }) -- 61
    end -- 3
  } -- 3
  if _base_0.__index == nil then -- 3
    _base_0.__index = _base_0 -- 3
  end -- 61
  _class_0 = setmetatable({ -- 3
    __init = function(self, api_key) -- 8
      self.api_key = api_key -- 9
    end, -- 3
    __base = _base_0, -- 3
    __name = "Notion" -- 3
  }, { -- 3
    __index = _base_0, -- 3
    __call = function(cls, ...) -- 3
      local _self_0 = setmetatable({ }, _base_0) -- 3
      cls.__init(_self_0, ...) -- 3
      return _self_0 -- 3
    end -- 3
  }) -- 3
  _base_0.__class = _class_0 -- 3
  local self = _class_0; -- 3
  self.base_url = "https://api.notion.com" -- 4
  self.timeout = 30 -- 5
  self.page_size = 100 -- 6
  Notion = _class_0 -- 3
end -- 61
_module_0 = Notion -- 63
return _module_0 -- 63
