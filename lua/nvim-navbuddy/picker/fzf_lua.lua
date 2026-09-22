local M = {}

---@private
---@param opts any
---@param display Navbuddy.display
function M.find(opts, display)
  local status_ok, fzf = pcall(require, "fzf-lua")
  if not status_ok then
    vim.notify("fzf-lua not found", vim.log.levels.ERROR)
    return
  end

  local navic = require("nvim-navic.lib")
  local utils = require("fzf-lua.utils")

  opts = vim.tbl_extend("force", {
    prompt = "Navbuddy> ",
    fzf_opts = {
      ["--no-multi"] = "",
    },
  }, opts or {})

  local bufnr = display.for_buf
  local children = display.focus_node.parent.children
  local results = {}

  for _, node in ipairs(children) do
    local kind = navic.adapt_lsp_num_to_str(node.kind)
    local kind_label = utils.ansi_codes.blue(
      string.format("%-14s", string.lower(kind))
    )
    table.insert(results, {
      node = node,
      entry = string.format("%d\t%s%s", #results, kind_label, node.name),
    })
  end

  local entries = vim.tbl_map(function(r)
    return r.entry
  end, results)

  local get_node = function(selected)
    local idx = tonumber(selected:match("^(%d+)\t"))
    if idx then
      return results[idx + 1].node
    end
  end

  display:close()

  fzf.fzf_exec(entries, vim.tbl_extend("force", opts, {
    preview = function(entry_str)
      local node = get_node(entry_str[1])
      if not node then
        return ""
      end
      local kind = navic.adapt_lsp_num_to_str(node.kind)
      local lnum = node.name_range["start"].line
      local start = math.max(0, lnum - 3)
      local finish = math.min(vim.api.nvim_buf_line_count(bufnr), lnum + 10)
      local lines = vim.api.nvim_buf_get_lines(bufnr, start, finish, false)
      return string.format("%s %s  [Ln %d]\n\n%s",
        kind, node.name, lnum, table.concat(lines, "\n"))
    end,
    actions = {
      ["default"] = function(selected)
        local node = get_node(selected[1])
        if node then
          display.focus_node = node
        end
        vim.schedule(function()
          require("nvim-navbuddy.display").new(display)
        end)
      end,
      ["ctrl-q"] = function(selected)
        local items = {}
        for _, sel in ipairs(selected) do
          local node = get_node(sel)
          if node then
            table.insert(items, {
              filename = vim.api.nvim_buf_get_name(bufnr),
              lnum = node.name_range["start"].line,
              col = node.name_range["start"].character,
              text = node.name,
            })
          end
        end
        vim.fn.setqflist(items, "r")
        vim.cmd("copen")
      end,
    },
  }))
end

return M
