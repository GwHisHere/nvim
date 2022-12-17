local cores = {
    "editer",
    "packer_init",
    "autocommands",
    "mappings",
    "colors",
}

for _, core in ipairs(cores) do
    local ok, err = pcall(require, "core." .. core)
    if not ok then
        error(("Error loading %s.lua...\n\n%s"):format(core, err))
    end
end

-- Slow use this one
-- require("core.packer_init")
-- require("core.settings")
-- require("core.autocmds")
-- require("core.mappings")