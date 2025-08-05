local M = {}

function M.getChests()
    local containers = { peripheral.find('minecraft:chest') }

    if #containers == 0 then
        error('No containers connected', 0)
    end

    return containers
end

function M.GetAllItems()
    local containers = M.getChests()
    local items = {}
    for i, c in pairs(containers) do
        local list = c.list()
        for slot, item in pairs(list) do
            local key = item.name
            if items[key] then
                items[key] = items[key] + item.count
            else
                items[key] = item.count
            end
        end
    end
    return items
end

return M
