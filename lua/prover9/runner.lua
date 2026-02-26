local M = {}

local function show_output(title, lines)
  vim.cmd("botright new")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "prover9_output"
  vim.api.nvim_buf_set_name(buf, title)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

local function write_temp_buffer()
  local path = vim.fn.tempname() .. ".p9"
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.fn.writefile(lines, path)
  return path, function()
    pcall(vim.fn.delete, path)
  end
end

local function input_file()
  if vim.bo.modified or vim.api.nvim_buf_get_name(0) == "" then
    return write_temp_buffer()
  end
  return vim.api.nvim_buf_get_name(0), function() end
end

local function binary_exists(bin)
  return vim.fn.executable(bin) == 1
end

local function run_single(bin)
  if not binary_exists(bin) then
    vim.notify(bin .. " not found in PATH", vim.log.levels.ERROR)
    return
  end

  local file, cleanup = input_file()
  local cmd = { bin, "-f", file }

  vim.system(cmd, { text = true }, function(obj)
    vim.schedule(function()
      cleanup()
      local lines = {
        "$ " .. table.concat(cmd, " "),
        "exit code: " .. tostring(obj.code),
        ""
      }

      if obj.stdout and obj.stdout ~= "" then
        vim.list_extend(lines, vim.split(obj.stdout, "\n", { plain = true }))
      end

      if obj.stderr and obj.stderr ~= "" then
        if #lines > 0 and lines[#lines] ~= "" then
          table.insert(lines, "")
        end
        table.insert(lines, "[stderr]")
        vim.list_extend(lines, vim.split(obj.stderr, "\n", { plain = true }))
      end

      show_output("[prover9.nvim] " .. bin, lines)
    end)
  end)
end

local function run_race()
  if not binary_exists("prover9") then
    vim.notify("prover9 not found in PATH", vim.log.levels.ERROR)
    return
  end
  if not binary_exists("mace4") then
    vim.notify("mace4 not found in PATH", vim.log.levels.ERROR)
    return
  end

  local file, cleanup = input_file()
  local done = false
  local p9
  local m4

  local function finish(winner, loser, obj)
    if done then
      return
    end
    done = true

    if loser then
      pcall(function()
        loser:kill(15)
      end)
    end

    cleanup()

    local lines = {
      "$ prover9 -f " .. file,
      "$ mace4 -f " .. file,
      "",
      "winner: " .. winner,
      "exit code: " .. tostring(obj.code),
      ""
    }

    if obj.stdout and obj.stdout ~= "" then
      vim.list_extend(lines, vim.split(obj.stdout, "\n", { plain = true }))
    end

    if obj.stderr and obj.stderr ~= "" then
      if #lines > 0 and lines[#lines] ~= "" then
        table.insert(lines, "")
      end
      table.insert(lines, "[stderr]")
      vim.list_extend(lines, vim.split(obj.stderr, "\n", { plain = true }))
    end

    show_output("[prover9.nvim] race", lines)
  end

  p9 = vim.system({ "prover9", "-f", file }, { text = true }, function(obj)
    vim.schedule(function()
      finish("prover9", m4, obj)
    end)
  end)

  m4 = vim.system({ "mace4", "-f", file }, { text = true }, function(obj)
    vim.schedule(function()
      finish("mace4", p9, obj)
    end)
  end)
end

function M.run_prover9()
  run_single("prover9")
end

function M.run_mace4()
  run_single("mace4")
end

function M.run_race()
  run_race()
end

return M
