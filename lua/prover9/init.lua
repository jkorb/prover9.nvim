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

local function register_parser(config)
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return
  end

  local parser_config = parsers.get_parser_configs()
  parser_config.prover9 = parser_config.prover9 or {}

  local local_repo = local_grammar_repo()
  local url = local_repo or config.grammar_url

  parser_config.prover9.install_info = {
    url = url,
    files = config.grammar_files,
    branch = config.grammar_branch,
    generate_requires_npm = false,
    requires_generate_from_grammar = false
  }
  parser_config.prover9.filetype = "prover9"

  pcall(vim.treesitter.language.register, "prover9", "mace4")
end

M.config = vim.deepcopy(default_config)

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), opts or {})
  register_parser(M.config)
end

return M
