local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = "[f] find files" })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = "[h] help tags" })
vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = "[t] treesitter" })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "[^p] git files" })
vim.keymap.set('n', '<leader>ss', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = "[s] grep prompt" })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = "[g] live grep file contents" })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = "[w] search for word under cursor" })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = "[d] Show diagnostics" })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = "[k] Show keymaps" })
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" });
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" });
vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = "[b] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = "[/] Fuzzily search in current buffer" });
