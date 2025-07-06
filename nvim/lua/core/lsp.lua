vim.lsp.enable({
    "gopls",
    "lua_ls",
    "robotframework_ls",
    "clangd",
    "rust_analyzer",
    "bashls",
    "pyright",
})

vim.diagnostic.config {

    underline = true,

    virtual_text = {
        prefix = "",
        severity = nil,
        source = "if_many",
        format = nil,
    },

    severity_sort = true,
    update_in_insert = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
}

