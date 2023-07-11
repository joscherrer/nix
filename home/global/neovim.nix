{ inputs, lib, pkgs, config, outputs, ... }:
{
  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    # plugins = with pkgs.vimPlugins; [
    #   lualine-nvim
    #   nvim-cmp
    #   nvim-lspconfig
    #   cmp-nvim-lsp
    #   cmp-buffer
    #   cmp-path
    #   cmp-cmdline
    #   mason-nvim
    #   mason-lspconfig-nvim
    # ];
  };

}
