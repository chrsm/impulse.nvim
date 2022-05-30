-- [yue]: ./impulse/menu.yue
local _module_0 = nil -- 1
local pjob = require("plenary.job") -- 1
local tsactions = require("telescope.actions") -- 2
local tsactionstate = require("telescope.actions.state") -- 3
local tsfinder = require("telescope.finders") -- 4
local tspicker = require("telescope.pickers") -- 5
local tsedisp = require("telescope.pickers.entry_display") -- 6
local tspreview = require("telescope.previewers") -- 7
local tsconf = require("telescope.config") -- 8
local page_menu -- 10
page_menu = function(results, opts) -- 10
  if results == nil then -- 10
    results = { } -- 10
  end -- 10
  if opts == nil then -- 10
    opts = nil -- 10
  end -- 10
  if not opts then -- 11
    error("no opts supplied") -- 11
  end -- 11
  local p = tspicker.new({ }, { -- 14
    prompt_title = opts.title, -- 14
    title = opts.make_title, -- 15
    finder = tsfinder.new_table({ -- 17
      results = results, -- 17
      entry_maker = opts.make_entry, -- 18
      title = opts.make_title -- 19
    }), -- 16
    previewer = tspreview.new_buffer_previewer({ -- 22
      define_preview = function(self, entry, status) -- 22
        local v = { -- 24
          "id: " .. tostring(entry.value.id), -- 24
          "url: " .. tostring(entry.value.url), -- 25
          "title: " .. tostring(entry.value.title) -- 26
        } -- 23
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, true, v) -- 28
        return vim.api.nvim_win_set_option(status.preview_win, 'wrap', true) -- 29
      end -- 22
    }), -- 21
    sorter = tsconf.values.generic_sorter({ }), -- 31
    attach_mappings = function(bufnr, map) -- 32
      tsactions.select_default:replace(function() -- 33
        tsactions.close(bufnr) -- 34
        local sel = tsactionstate.get_selected_entry() -- 35
        local _obj_0 = opts.select -- 36
        if _obj_0 ~= nil then -- 36
          return _obj_0(sel) -- 36
        end -- 36
        return nil -- 36
      end) -- 33
      return true -- 38
    end -- 32
  }) -- 13
  return p:find() -- 41
end -- 10
local input_menu -- 43
input_menu = function(opts) -- 43
  if not opts then -- 44
    error("impulse.nvim (internal): no `opts` supplied to input_menu") -- 45
  end -- 44
  local has_nui, nui = pcall(require, "nui.input") -- 47
  if has_nui then -- 48
    local ntyp = require("nui.utils.autocmd") -- 49
    local input = nui({ -- 52
      size = { -- 53
        width = 50, -- 53
        height = 20 -- 54
      }, -- 52
      position = { -- 56
        row = 0, -- 56
        col = 0 -- 57
      }, -- 55
      relative = "cursor", -- 58
      border = { -- 60
        highlight = "ImpulseInputHi", -- 60
        style = "rounded", -- 61
        text = { -- 63
          top = opts.title, -- 63
          top_align = "center" -- 64
        } -- 62
      }, -- 59
      win_options = { -- 66
        winblend = 10, -- 66
        winhighlight = "Normal:Normal" -- 67
      } -- 65
    }, { -- 69
      prompt = "> ", -- 69
      default_value = "", -- 70
      on_submit = function(v) -- 71
        return opts.on_submit(v) -- 72
      end -- 71
    }) -- 51
    input:mount() -- 75
    input:on(ntyp.event.BufLeave, function() -- 76
      return input:unmount() -- 77
    end) -- 76
    input:on(ntyp.event.InsertLeave, function() -- 78
      return input:unmount() -- 79
    end) -- 78
  else -- 81
    local v = vim.fn.input(opts.input_text) -- 81
    opts.on_submit(v) -- 82
  end -- 48
  return nil -- 84
end -- 43
_module_0 = { -- 87
  page = page_menu, -- 87
  input = input_menu -- 88
} -- 86
return _module_0 -- 89
