local M = {}

local default_config = {
  grammar_url = "https://github.com/jkorbmacher/prover9_treesitter",
  grammar_branch = "main",
  grammar_files = { "src/parser.c" }
}

local function plugin_root()
  local source = debug.getinfo(1, "S").source:sub(2)
  return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(source)))
end

local function local_grammar_repo()
  local path = vim.fs.normalize(plugin_root() .. "/../prover9_treesitter")
  if vim.uv.fs_stat(path .. "/grammar.js") then
    return path
  end
  return nil
end

local function resolve_parser_configs(parsers)
  if type(parsers) ~= "table" then
    return nil
  end
  if type(parsers.get_parser_configs) == "function" then
    return parsers.get_parser_configs()
  end
  return parsers
end

local function register_parser(config)
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return false
  end

  local parser_configs = resolve_parser_configs(parsers)
  if type(parser_configs) ~= "table" then
    return false
  end

  parser_configs.prover9 = parser_configs.prover9 or {}

  local local_repo = local_grammar_repo()
  local install_info = {
    files = config.grammar_files,
    branch = config.grammar_branch,
    generate_requires_npm = false,
    requires_generate_from_grammar = false
  }

  if local_repo then
    install_info.path = local_repo
  else
    install_info.url = config.grammar_url
  end

  parser_configs.prover9.install_info = install_info
  parser_configs.prover9.filetype = "prover9"

  pcall(vim.treesitter.language.register, "prover9", "mace4")
  return true
end

M.config = vim.deepcopy(default_config)

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), opts or {})
  return register_parser(M.config)
end

return M
