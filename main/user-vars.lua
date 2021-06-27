local home = os.getenv("HOME")

local val = {
    terminal = "alacritty",
    editor = os.getenv("EDITOR") or "code",
    modkey = "Mod4"
}

return val
