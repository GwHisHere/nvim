local fn = vim.fn
local fmt = string.format

local function fname()
    local filename = fn.expand "%:t"
    local extension = fn.expand "%:e"
    local path = fn.expand "%:h"
    local mod = "/%#Statusline#"

    if not path ~= 0 then
        if vim.api.nvim_buf_get_option(0, "mod") then
            mod = "/%#Winbar#"
        end
        path = "%#StatusLineNC# " .. path .. mod .. filename .. "%*"
    end

    local file_icon, file_icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

    local hl_group = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })

    if file_icon == nil then
        file_icon = ""
        file_icon_color = ""
    end

    file_icon = "%#" .. hl_group .. "#" .. file_icon .. "%*"
    return string.format("%s%s", file_icon, path)
end

local function encoding()
    local opt = vim.opt.fileencoding:get()
    return fmt("[%s] ", opt):upper()
end

local function filesize()
    local file = fn.expand "%:p"

    if file == nil or #file == 0 then
        return ""
    end

    local size = fn.getfsize(file)

    if size <= 0 then
        return ""
    end

    local suffixes = { "b", "k", "m", "g" }
    local i = 1
    while size > 1024 and i < #suffixes do
        size = size / 1024
        i = i + 1
    end
    local format = i == 1 and " %d%s" or " %.1f%s"
    return fmt(format, size, suffixes[i])
end

local function diagnostic_status()
    local count = {}
    local levels = {
        errors = "Error",
        warnings = "Warn",
        info = "Info",
        hints = "Hint",
    }

    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ""
    local warnings = ""
    local hints = ""
    local info = ""

    if count["errors"] ~= 0 then
        errors = "%#DiagnosticSignError#  " .. count["errors"]
    end
    if count["warnings"] ~= 0 then
        warnings = "%#DiagnosticSignWarn#  " .. count["warnings"]
    end
    if count["hints"] ~= 0 then
        hints = "%#DiagnosticSignHint#  " .. count["hints"]
    end
    if count["info"] ~= 0 then
        info = "%#DiagnosticSignInfo#  " .. count["info"]
    end

    return errors .. warnings .. hints .. info .. "%*"
end

local function clientName()
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return ""
    end
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return " " .. string.upper(client.name) .. "  |"
        end
    end
    return ""
end

local navic_loaded, navic = pcall(require, "nvim-navic")

navic.setup {
    icons = {
        File = "file ",
        Module = "module ",
        Namespace = "namespace ",
        Package = "package ",
        Class = "class ",
        Method = "method ",
        Property = "property ",
        Field = "field ",
        Constructor = "constructor ",
        Enum = "enum ",
        Interface = "interface ",
        Function = "function ",
        Variable = "variable ",
        Constant = "constant ",
        String = "string ",
        Number = "number ",
        Boolean = "boolean ",
        Array = "array ",
        Object = "object ",
        Key = "key ",
        Null = "null ",
        EnumMember = "enum member ",
        Struct = "struct ",
        Event = "event ",
        Operator = "operator ",
        TypeParameter = "type parameter ",
    },
    highlight = true,
    separator = " " .. "❭" .. " ",
    depth_limit = 0,
    depth_limit_indicator = "..",
}

local get_navic = function()
    if not navic_loaded then
        return ""
    end

    local navic_location_loaded, navic_location = pcall(navic.get_location, {})

    if not navic_location_loaded then
        return ""
    end

    if not navic.is_available() or navic_location == "error" then
        return ""
    end

    if not navic_location == nil then
        return "❭" .. " " .. navic_location
        -- return require("config.navic").separator .. " " .. navic_location
    end

    return ""
end

local function get_paste()
    return vim.o.paste and "PASTE " or ""
end

local function get_readonly_space()
    return ((vim.o.paste and vim.bo.readonly) and " " or "") and "%r" .. (vim.bo.readonly and " " or "")
end

local function statusline()
    local parts = {
        clientName(),
        fname(),
        get_navic(),
        get_paste(),
        get_readonly_space(),
        "%=", -- To make a large space everything down is on the right side
        diagnostic_status(),
        "%1l/%L:%1c%*",
        filesize(),
        encoding(),
    }
    return table.concat(parts, " ")
end

return { statusline = statusline }
