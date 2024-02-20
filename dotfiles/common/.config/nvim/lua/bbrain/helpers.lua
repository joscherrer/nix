function ToggleTheme()
  if vim.o.background == "dark" then
    vim.cmd("colorscheme onelight")
  else
    vim.cmd("colorscheme onedark")
  end
end

vim.api.nvim_create_user_command('ToggleTheme', ToggleTheme, {})
