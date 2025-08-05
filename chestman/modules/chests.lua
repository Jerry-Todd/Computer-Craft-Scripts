
local M = {}

-- function M.getChests()
    

--     return chests
-- end

function M.GetAllItems()
    local containers = { peripheral.find('minecraft:chest') }

    if #containers == 0 then
        error('No containers connected', 0)
    end
    for i, c in pairs(containers) do
        print((c.list().tostring))
    end
end

return M