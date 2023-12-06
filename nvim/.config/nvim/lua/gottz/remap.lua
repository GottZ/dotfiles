vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-down>", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--vim.keymap.set("n", "<leader>vwm", function()
--    require("vim-with-me").StartVimWithMe()
--end)
--vim.keymap.set("n", "<leader>svwm", function()
--    require("vim-with-me").StopVimWithMe()
--end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/gottz/packer.lua<CR>");
vim.keymap.set("n", "<leader>vpr", "<cmd>e ~/.config/nvim/lua/gottz/remap.lua<CR>");
vim.keymap.set("n", "<leader>vps", "<cmd>e ~/.config/nvim/lua/gottz/set.lua<CR>");
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set("n", "<leader>t", ":term<CR>")
vim.keymap.set("t", "<Esc>(", "<C-\\><C-n>")

--vim.keymap.set("n", "<leader><TAB>", ":bn<CR>")
--vim.keymap.set("n", "<S-TAB>", ":bp<CR>")

local function get_visual_selection()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")

    --print(vim.inspect(s_start))
    --print(vim.inspect(s_end))

    --local reversed = false
    if (s_start[2] > s_end[2] or (s_start[2] == s_end[2] and s_start[3] > s_end[3])) then
        --reversed = true
        local temp = s_start
        s_start = s_end
        s_end = temp
    end

    local lcount = s_end[2] - s_start[2] + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    -- strip unselected content from the first line. (still have to figure out
    -- how to do this with ctrl + v too for each line..
    lines[1] = string.sub(lines[1], s_start[3], -1)

    if lcount == 1 then
        -- remove the trailing line stuff that was not selected if 1st line
        lines[lcount] = string.sub(lines[lcount], 1, s_end[3] - s_start[3] + 1)
    else
        -- remove trailing from last line. still have to find a way for ctrl+v
        lines[lcount] = string.sub(lines[lcount], 1, s_end[3])
    end

    return table.concat(lines, "\n")
end

local overlay = require("gottz.overlay")

local function gen_qr(content)
    local response = require("gottz.exec").python([[
        import qrcode
        qr = qrcode.QRCode(version = 1, border = 1, box_size = 1,
                           error_correction = qrcode.constants.ERROR_CORRECT_L)
        qr.add_data(_get())
        qr.make(fit=True)
        qr.print_ascii(_writer)
    ]], content)

    overlay.show("QR", (string.gsub(response, "%s+$", "")))
end

-- buffer shizz https://jacobsimpson.github.io/nvim-lua-manual/docs/buffers-and-windows/
-- fix selection with: https://stackoverflow.com/questions/42714836/setpos-and-getpos-strange-behavior-in-vim
vim.keymap.set({ "v", "n" }, "<leader>qr", function() gen_qr(get_visual_selection()) end)
vim.keymap.set("n", "<leader>qqr", function() overlay.close() end)

-- Hallo ballo!
