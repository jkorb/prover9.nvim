local ok, prover9 = pcall(require, "prover9")
if not ok then
  return
end

prover9.setup()

local runner = require("prover9.runner")

vim.api.nvim_create_user_command("Prover9Run", runner.run_prover9, {
  desc = "Run prover9 -f against current file or buffer"
})

vim.api.nvim_create_user_command("Mace4Run", runner.run_mace4, {
  desc = "Run mace4 -f against current file or buffer"
})

vim.api.nvim_create_user_command("Prover9Mace4Race", runner.run_race, {
  desc = "Run prover9 and mace4 together; stop the loser when one returns"
})
