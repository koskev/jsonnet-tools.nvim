{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    grustonnet.url = "github:koskev/grustonnet-ls";
    recordings.url = "git+https://codeberg.org/kokev/lsp-recorder.git";
  };

  outputs =
    inputs@{
      flake-parts,
      self,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        let
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "jsonnet-tools.nvim";
            src = self;
          };
          baseNeovim = inputs.recordings.lib.${system}.baseNeovim.mkNeovim {
            treesitterPlugins = [ "jsonnet" ];
            extraConfig = ''
              vim.lsp.config['grustonnet'] = {
                cmd = { "grustonnet-ls" },
                filetypes = { 'jsonnet', 'libsonnet' },
                root_markers = { 'jsonnetfile.json', '.git' },
              }
              vim.lsp.enable('grustonnet')
              require('jsonnet-tools').setup({language_server_name="grustonnet"})
            '';
            extraPlugins = with pkgs.vimPlugins; [
              plugin
              nvim-dap
            ];
          };

        in
        {
          packages = {
            default = plugin;
          };
          apps.default = {
            type = "app";
            program = "${baseNeovim}/bin/nvim";
          };
        };
    };
}
