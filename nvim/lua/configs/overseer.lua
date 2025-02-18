local setup = function()
    require("overseer").setup({
        templates = { "builtin", "user.cpp_build" },
        --templates = { "builtin", "user.run_script" },
    })
end

local M = {
    setup = setup,
}

return M
