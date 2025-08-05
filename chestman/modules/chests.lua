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
        local chestName = peripheral.getName(c)
        print(" - Chest: " .. chestName)
        local items = c.list()
        for slot, item in pairs(items) do
            print("  Slot " .. slot .. ": " .. item.name .. " x" .. item.count)
        end
        print() -- Empty line for better readability between chests
    end
end

return M
