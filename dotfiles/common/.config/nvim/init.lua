-- load sqlite.lua on NixOS
if vim.fn.filereadable(vim.fn.stdpath('config') .. '/lua/nix/sqlite.lua') ~= 0 then
    require('nix.sqlite')
end

require("bbrain")

vim.filetype.add({
    extension = {
        tf = "terraform",
        envrc = "sh",
    }
})
