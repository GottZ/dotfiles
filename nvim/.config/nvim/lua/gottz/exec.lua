local strings = require("gottz.strings")

local M = {}

local _std = strings.unindent([[
    def _get():
        return "\n".join(vim.request("nvim_buf_get_lines", __buff_id, 0, -1, False))
    def _set(data):
        vim.request("nvim_buf_set_lines", __buff_id, 0, -1, True, ("%s" % data).split("\n"))
    class __writer():
        def __init__(self):
            self.buf = ""
        def write(self, data):
            self.buf = "%s%s" % (self.buf, data)
        def flush(self):
            _set(self.buf)
    _writer = __writer()
    __buff_id =
]])

function M.python(code, data)
    local buff_id = vim.api.nvim_create_buf(false, false)
    local data_t = {}
    for s in string.gmatch(data, "[^\n]+") do
        table.insert(data_t, s)
    end

    code = _std .. buff_id .. "\n" .. strings.unindent(code)

    vim.api.nvim_buf_set_text(buff_id, 0, 0, 0, 0, data_t)

    vim.cmd.python(code)

    local response = vim.api.nvim_buf_get_lines(buff_id, 0, -1, false)

    vim.api.nvim_buf_delete(buff_id, { force = true })

    return table.concat(response, "\n")
end

function M.unload()
    package.loaded["gottz.exec"] = nil
end

return M

