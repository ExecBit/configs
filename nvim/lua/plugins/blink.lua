return {
    'saghen/blink.nvim',
    build = 'cargo build --release', -- for delimiters

    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
    },
}
