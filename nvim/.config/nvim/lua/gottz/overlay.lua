local K = {}

local popup = require("plenary.popup")

Overlay_win_id = nil
Overlay_bufh = nil

function K.close()
    if (Overlay_win_id == nil) then return end
    -- TODO: close buffer first and then check if the window is still open
    vim.api.nvim_win_close(Overlay_win_id, true)
    vim.api.nvim_buf_delete(Overlay_bufh, { force = true })
    Overlay_win_id = nil
    Overlay_bufh = nil
end

local function open(title, width, height)
    if (Overlay_win_id ~= nil) then K.close() end
    --print(contents)
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local bufnr = vim.api.nvim_create_buf(false, false)
    local win_id, win = popup.create(bufnr, {
        title = title,
        highlight = "QRWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })

    vim.api.nvim_win_set_option(
        win.border.win_id,
        "winhl",
        "Normal:QRBorder"
    )

    return {
        bufnr = bufnr,
        win_id = win_id,
    }
end

function K.show(title, content)
    local contents = {}

    local width = 0

    for s in string.gmatch(content, "[^\r\n]+") do
        width = math.max(width, vim.api.nvim_strwidth(s))
        table.insert(contents, s)
    end
    --for s in string.gmatch(source, "[^\r\n]+") do
    --    width = math.max(width, vim.api.nvim_strwidth(s))
    --    table.insert(contents, s)
    --end

    local height = #contents

    local win_info = open(title, width, height)

    Overlay_win_id = win_info.win_id
    Overlay_bufh = win_info.bufnr

    vim.api.nvim_buf_set_text(win_info.bufnr, 0, 0, 0, 0, contents)
    -- vim.cmd [[ redraw ]]
end

return K
