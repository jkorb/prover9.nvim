local ok, runner = pcall(require, "prover9.runner")
if not ok then
  return
end

local function register_parser()
  pcall(function()
    require("prover9").setup()
  end)
end

register_parser()

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = register_parser,
  desc = "Ensure prover9 parser config is registered for nvim-treesitter"
})

vim.api.nvim_create_user_command("Prover9Run", runner.run_prover9, {
  desc = "Run prover9 -f against current file or buffer"
})

vim.api.nvim_create_user_command("Mace4Run", runner.run_mace4, {
  desc = "Run mace4 -f against current file or buffer"
})

vim.api.nvim_create_user_command("Prover9Mace4Race", runner.run_race, {
  desc = "Run prover9 and mace4 together; stop the loser when one returns"
})
