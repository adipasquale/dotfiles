local severity_map = {
  ["fatal"] = vim.diagnostic.severity.ERROR,
  ["error"] = vim.diagnostic.severity.ERROR,
  ["warning"] = vim.diagnostic.severity.WARN,
  ["convention"] = vim.diagnostic.severity.HINT,
  ["refactor"] = vim.diagnostic.severity.INFO,
  ["info"] = vim.diagnostic.severity.INFO,
}

return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters.slim_lint = {
        cmd = "bundle",
        stdin = false, -- Disable stdin since slim-lint works with files
        args = { "exec", "slim-lint", "--reporter", "json" },
        append_fname = true,
        stream = "stdout",
        ignore_exitcode = true, -- Slim-lint returns non-zero exit codes on lint errors, we can ignore those
        parser = function(output)
          local diagnostics = {}
          local decoded = vim.json.decode(output)

          if not decoded.files[1] then
            return diagnostics
          end

          local offences = decoded.files[1].offenses

          for _, off in pairs(offences) do
            local col = string.len(vim.api.nvim_buf_get_lines(0, off.location.line - 1, off.location.line, true)[1])
            table.insert(diagnostics, {
              source = "slim-lint",
              lnum = off.location.line - 1,
              end_lnum = off.location.line - 1,
              col = col + 1,
              end_col = col + 1,
              severity = severity_map[off.severity],
              message = off.message,
              code = off.linter,
            })
          end

          return diagnostics
        end,
      }
    end,
  },
}
