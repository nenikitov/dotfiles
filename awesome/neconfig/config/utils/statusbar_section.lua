local statusbar_section = {}


function statusbar_section:new(args)
    self.arg = args

    return self
end

function statusbar_section:print()
end



return setmetatable(
    statusbar_section,
    { __call = function(_,...) return statusbar_section:new(...) end }
)
