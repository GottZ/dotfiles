function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

--ColorMyPencils()
vim.api.nvim_create_user_command("ColorMyPencils", function() ColorMyPencils() end, { nargs = 0 })
