# Neovim Native re-write

We want to use the new native neovim builtin tools to rewrite our current nvim configuration.

- We want to use the native package manager to replace lazy.
- We want to use the native lsp api to replace Mason.

## DO NOT
DO NOT Make any changes that impacts neovim functionalities or keymaps as they currently stand.

## IMPORTANT

To replace mason-lsp it means that the lsp must be available in the system.
Remeber we're using nixos. So install them by adding them to the nixos config, you can find
it at `~/dotfiles/nixos/`. If no nix pkgs is avaiable use as command for the lsp something like
`npx` or `uvx` as done in `../my-opencode/opencode.json` lsp section.
You can use the nixos MCP if you find it useful.

### Before proceding

What's the best general solution for the lsp installing in my sytem or installing them selecitvely with 
tools such as `npx` or `uvx`?

## Additional

If you make any changes in the `~/dotfiles/nixos/` I'll rebuild the system myself.
