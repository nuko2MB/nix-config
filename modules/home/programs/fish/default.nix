{
  lib,
  config,
  osConfig,
  ...
}@args:
lib.nuko.mkModule args
  [
    "programs"
    "fish"
  ]
  {
    programs.fish =
      let
        inherit (osConfig.programs.nh) flake;
      in
      {
        enable = true;
        interactiveShellInit = ''

          # TODO: command-not-found error with flakes. Use nix-index as a workaround.
          function fish_command_not_found
            __fish_default_command_not_found_handler $argv
          end

          function @
            if test -n "$argv[1]"
              switch $argv[1]
                case rebuild
                  command git -C ${flake} add --all 
                  command nh os switch -a $argv[2..-1]
                case repl
                  command nix repl --expr 'import <nixpkgs>{}'
                case edit
                  command code ${flake}
                case '*'
                  @ rebuild $argv
              end
            else
              @ rebuild $argv
            end
          end
        '';
      };
  }
