local fn = vim.fn
local M = {}

-- From: https://github.com/jghauser/mkdir.nvim
-- Create a folder if does not exist
function M.mkdir()
    local dir = fn.expand "<afile>:p:h"
    -- This handles URLs using netrw. See ':help netrw-transparent' for details.
    if dir:find "%l+://" == 1 then
        return
    end

    if fn.isdirectory(dir) == 0 then
        fn.mkdir(dir, "p")
    end
end

return M
