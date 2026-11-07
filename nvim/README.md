# nvim

## Directory structure

- `config`, and `plugin` have the same structure, grouped by topic
- Topics (in order):
    | # | Topic | Meaning | Notes | Examples
    | --- | --- | --- | --- | --- |
    | 1 | `target` | Toolchain specific, what project technologies are targeted | Not necessarily by file extension: rust target should also install toml | Specific LSP clients, specific parsers, specific debuggers
    | 2 | `core` | Everything about understanding code + monolithic plugins that can't be split | | LSP, Treesitter, and DAP bootstrap, completion, snippets, diagnostics + Snacks
    | 3 | `workspace` | Moving between and manipulating files, windows, and sessions, version control | | File pickers and browsers, project-wide search and replace, git integration
    | 4 | `editing` | Directly changes or navigates the text | | Surround, autopairs, pasting, jump, folds
    | 5 | `interface` | Everything else, look and feel | | Dashboard, icons, colorscheme, bars
