local function detect_in(path, bufnr)
  local lower_path = path:lower()

  if lower_path:match("mace4") then
    return "mace4"
  end
  if lower_path:match("prover9") then
    return "prover9"
  end

  if not bufnr or bufnr == 0 or not vim.api.nvim_buf_is_valid(bufnr) then
    return "prover9"
  end

  local ok_count, line_count = pcall(vim.api.nvim_buf_line_count, bufnr)
  if not ok_count then
    return "prover9"
  end

  local max_lines = math.min(120, line_count)
  local ok_lines, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, 0, max_lines, false)
  if not ok_lines then
    return "prover9"
  end

  local text = table.concat(lines, "\n"):lower()
  if text:find("if%s*%(%s*mace4%s*%)") or text:find("assign%s*%(%s*max_models") then
    return "mace4"
  end

  return "prover9"
end

vim.filetype.add({
  extension = {
    p9 = "prover9",
    prover9 = "prover9",
    m4 = "mace4",
    mace4 = "mace4",
    ["in"] = detect_in
  },
  filename = {
    ["prover9.in"] = "prover9",
    ["mace4.in"] = "mace4"
  },
  pattern = {
    [".*[Pp]rover9.*%.in$"] = "prover9",
    [".*[Mm]ace4.*%.in$"] = "mace4"
  }
})
