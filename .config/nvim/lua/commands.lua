-- trim trailing white spaces on save
-- https://vi.stackexchange.com/a/37427
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- rubocop config with lspconfig cf https://docs.rubocop.org/rubocop/usage/lsp.html
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "ruby",
-- 	callback = function()
-- 		vim.lsp.start({
-- 			name = "rubocop",
-- 			cmd = { "bundle", "exec", "rubocop", "--lsp" },
-- 		})
-- 	end,
-- })

-- setup autocorrect ruby files with rubocop upon save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rb",
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- Set up an autocmd to trigger linting on save for SLIM files
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.slim" },
  callback = function()
    require("lint").try_lint("slim_lint")
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.slim" },
  command = "setlocal filetype=slim",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "slim",
  callback = function()
    vim.bo.commentstring = "/ %s"
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

-- from https://www.reddit.com/r/neovim/comments/u221as/how_can_i_copy_the_current_buffers_relative_path/
vim.api.nvim_create_user_command("Cppath", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- open all changed files on current branch and highlights changes with gitsigns
vim.api.nvim_create_user_command("OpenChangedFiles", function()
  local base = vim.fn.systemlist("git merge-base production HEAD")[1]
  for file in io.popen("git diff --name-only " .. base):lines() do
    vim.cmd.edit(file)
  end
  vim.cmd("Gitsigns change_base " .. base)
end, {})
