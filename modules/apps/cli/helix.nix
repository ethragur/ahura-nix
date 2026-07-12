{ self
, inputs
, ...
}:
{
  flake.nixosModules.helix =
    { pkgs
    , lib
    , ...
    }:
    {
      home-manager.sharedModules = [
        inputs.self.homeModules.helix
      ];
    };

  flake.homeModules.helix =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      stylix.targets.helix.enable = true;


      programs.helix = {
        enable = true;
        # package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.helix;
        languages = with pkgs; {
          language = [
            { name = "nix"; auto-format = true; indent = { tab-width = 4; unit = " "; }; }
            { name = "gdscript"; file-types = [ "gd" ]; language-servers = [ "gdscript" ]; indent = { tab-width = 4; unit = ""; }; }
            { name = "yaml"; file-types = [ "yaml" "yml" ]; language-servers = [ "yaml-language-server" ]; indent = { tab-width = 4; unit = ""; }; }
            { name = "python"; language-servers = [ "pylsp" ]; indent = { tab-width = 4; unit = ""; }; }
            { name = "rust"; language-servers = [ "rust-analyzer" ]; indent = { tab-width = 4; unit = ""; }; }
            { name = "php"; language-servers = [ "phpactor" ]; indent = { tab-width = 4; unit = ""; }; }
            { name = "nickel"; language-servers = [ "nls" ]; indent = { tab-width = 4; unit = ""; }; }
            { name = "elixir"; file-types = [ "ex" "exs" "heex" ]; roots = [ "mix.exs" ]; comment-token = "#"; scope = "source.elixir"; auto-format = true; language-servers = [ "elixir-ls" ]; indent = { tab-width = 2; unit = " "; }; }
          ];
          language-server = {
            nil = {
              command = "${pkgs.nil}/bin/nil";
              config.nil = {
                formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
                nix.flake.autoEvalInputs = true;
              };
            };
            phpactor = {
              command = "${pkgs.phpactor}/bin/phpactor";
              args = [ "language-server" ];
            };
            gdscript = {
              command = "${pkgs.netcat}/bin/nc";
              args = [ "127.0.0.1" "6005" ];
            };
            elixir-ls = {
              command = "${pkgs.elixir-ls}/bin/elixir-ls";
              auto-format = true;
            };
            rust-analyzer = {
              command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
              formatter = {
                command = "${pkgs.rustfmt}";
              };
              auto-format = true;
              config = {
                inlayHints.bindingModeHints.enable = false;
                inlayHints.closingBraceHints.minLines = 10;
                inlayHints.closureReturnTypeHints.enable = "with_block";
                inlayHints.discriminantHints.enable = "fieldless";
                inlayHints.lifetimeElisionHints.enable = "skip_trivial";
                inlayHints.typeHints.hideClosureInitialization = false;
              };
            };
            yaml-language-server = {
              command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
            };
            pylsp = {
              command = "${pkgs.python313Packages.python-lsp-server}/bin/pylsp";
              auto-format = true;
              formatter = {
                command = "${pkgs.python313Packages.black}/bin/black";
              };
            };
            volar = {
              command = "${pkgs.vscode-extensions.vue.volar}/bin/vue-language-server";
              args = [ "--stdio" ];
              auto-format = true;
            };
            nls = {
              command = "${pkgs.nls}/bin/nls";
            };
          };
        };
        settings = {
          editor = {
            line-number = "relative";
            lsp.display-messages = true;
            cursorline = true;
            color-modes = true;
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
            indent-guides.render = true;
            insert-final-newline = false;
            bufferline = "always";
            auto-pairs = false;
          };
          # Thanks to: https://github.com/LGUG2Z/helix-vim
          keys.normal = {
            "C-o" = ":config-open";
            "C-r" = ":config-reload";
            "A-h" = ":buffer-previous";
            "A-l" = ":buffer-next";
            space.space = "file_picker";
            "0" = "goto_line_start";
            "$" = "goto_line_end";
            G = "goto_file_end";
            D = [ "extend_to_line_end" "yank_main_selection_to_clipboard" "delete_selection" ];
            V = [ "select_mode" "extend_to_line_bounds" ];
            Y = "yank_to_clipboard";
          };
          keys.select = {
            "{" = [ "extend_to_line_bounds" "goto_prev_paragraph" ];
            "}" = [ "extend_to_line_bounds" "goto_next_paragraph" ];
            "0" = "goto_line_start";
            G = "goto_file_end";
            "%" = "match_brackets";
            D = [ "extend_to_line_end" "yank_main_selection_to_clipboard" "delete_selection" ];
          };
        };
      };
    };

  # perSystem = { pkgs, lib, ... }:
  #   let
  #     mkNixPak = inputs.nixpak.lib.nixpak {
  #       inherit (pkgs) lib;
  #       inherit pkgs;
  #     };

  #     wrap = package: config: (mkNixPak {
  #       config = { sloth, ... }:
  #         lib.recursiveUpdate
  #           {
  #             app.package = package;
  #             bubblewrap.network = false;
  #           }
  #           (config sloth);
  #     }).config.script;
  #   in
  #   {
  #     packages = {
  #       helix = wrap pkgs.helix (sloth: {
  #         bubblewrap.network = true;
  #         bubblewrap.bind.rw = [
  #           (sloth.concat' sloth.homeDir "/.config/helix")
  #           (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/helix"))
  #           (sloth.mkdir (sloth.concat' sloth.homeDir "/.cache/helix"))
  #         ];
  #       });
  #     };
  #   };
}
