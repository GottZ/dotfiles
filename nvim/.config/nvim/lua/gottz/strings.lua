local M = {}

function M.unindent(data)
    --print(vim.inspect(lines))
    --local prefix = string.match(lines[0], "^(%s+)")
    local prefix = nil
    local out = {}

    for line in string.gmatch(data, "[^\n]+") do
        --table.insert(out, line)
        if prefix == nil then
            prefix = string.match(line, "^%s+")
            if (prefix == nil) then prefix = "" end
        end
        table.insert(out, (line:gsub("^" .. prefix, "")))
    end
    --return "'" .. prefix .. "'"
    return table.concat(out, "\n")
end

function M.unload()
    package.loaded["gottz.strings"] = nil
end

return M

-- lua package.loaded["gottz.strings"] = nil; print(require("gottz.strings").unindent("   foo\n   bar\n\n     nom"))
