-- [yue]: ./impulse/api.yue
local _module_0 = nil -- 1
local request = require("http.request") -- 1
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
      local req = request.new_from_uri(tostring(self.__class.base_url) .. "/" .. tostring(api)) -- 12
      req.headers:upsert(":method", method) -- 14
      req.headers:upsert("user-agent", "impulse.nvim-0.1-alpha") -- 15
      req.headers:append("x-req-by", "impulse.nvim") -- 16
      req.headers:append("accept", "application/json") -- 17
      req.headers:append("content-type", "application/json") -- 18
      req.headers:append("authorization", "Bearer " .. tostring(self.api_key)) -- 19
      req.headers:append("notion-version", "2022-02-22") -- 20
      if body then -- 22
        req:set_body(vim.json.encode(body)) -- 24
      end -- 22
      local head, resp = req:go(timeout) -- 26
      if not head then -- 27
        return error("unable to make request to " .. tostring(api)) -- 28
      end -- 27
      return vim.json.decode(resp:get_body_as_string()) -- 30
    end, -- 35
    get_page = function(self, id) -- 35
      return self:_request("v1/pages/" .. tostring(id)) -- 36
    end, -- 39
    update_page = function(self, id, data) -- 39
      if data == nil then -- 39
        data = nil -- 39
      end -- 39
      return self:_request("v1/pages/" .. tostring(id), "PATCH", data) -- 40
    end, -- 43
    get_block = function(self, id) -- 43
      return self:_request("v1/blocks/" .. tostring(id)) -- 44
    end, -- 48
    get_blocks = function(self, parent_id, start_cursor, page_size) -- 48
      if start_cursor == nil then -- 48
        start_cursor = 0 -- 48
      end -- 48
      if page_size == nil then -- 48
        page_size = self.__class.page_size -- 48
      end -- 48
      local qs = "page_size=" .. tostring(page_size) -- 49
      if start_cursor > 0 then -- 50
        qs = qs .. "&start_cursor=" .. tostring(start_cursor) -- 50
      end -- 50
      return self:_request("v1/blocks/" .. tostring(parent_id) .. "/children?" .. tostring(qs)) -- 52
    end, -- 55
    search = function(self, query, filter) -- 55
      if query == nil then -- 55
        query = "" -- 55
      end -- 55
      if filter == nil then -- 55
        filter = nil -- 55
      end -- 55
      if not filter then -- 56
        filter = { -- 58
          property = "object", -- 58
          value = "page" -- 59
        } -- 57
      end -- 56
      return self:_request("v1/search", "POST", { -- 62
        query = query, -- 62
        filter = filter -- 62
      }) -- 62
    end -- 3
  } -- 3
  if _base_0.__index == nil then -- 3
    _base_0.__index = _base_0 -- 3
  end -- 62
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
end -- 62
_module_0 = Notion -- 64
return _module_0 -- 64
