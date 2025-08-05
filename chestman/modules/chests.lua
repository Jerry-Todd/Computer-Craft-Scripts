local M = {}

function M.getChests()
    local containers = { peripheral.find('minecraft:chest') }

    if #containers == 0 then
        error('No containers connected', 0)
    end
end

function M.GetAllItems()
    for i, c in pairs(containers) do
        print(c.list())
    end
end

return M
