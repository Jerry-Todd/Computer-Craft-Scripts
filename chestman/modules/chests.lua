local M = {}

function M.GetChests()
    local containers = { peripheral.find('minecraft:chest') }

    if #containers == 0 then
        error('No containers connected', 0)
    end

    return containers
end

function M.GetInterface()
    local interface = peripheral.find('minecraft:barrel')

    if not interface then
        error('No interface barrel connected', 0)
    end

    return interface
end

function M.GetAllItems()
    local containers = M.GetChests()
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

function M.TakeItem(targetItem, quantity)
    local containers = M.GetChests()
    local interface = M.GetInterface()
    local interfaceName = peripheral.getName(interface)
    local totalMoved = 0

    quantity = quantity or 64

    for i, c in pairs(containers) do
        if totalMoved >= quantity then break end

        local list = c.list()
        for slot, item in pairs(list) do
            if totalMoved >= quantity then break end

            if item.name == targetItem then
                local toMove = math.min(item.count, quantity - totalMoved)
                local moved = c.pushItems(interfaceName, slot, toMove)
                totalMoved = totalMoved + moved
            end
        end
    end

    return totalMoved
end

function M.DepositAll()
    local containers = M.GetChests()
    local interface = M.GetInterface()
    local totalDeposited = 0

    -- Keep trying until no more items can be moved
    local itemsMoved = true
    while itemsMoved do
        itemsMoved = false
        local interfaceInv = interface.list()

        -- For each item in the interface barrel
        for slot, item in pairs(interfaceInv) do
            local itemName = item.name
            local itemCount = item.count

            -- First, try to find chests that already contain this item type
            local foundMatchingChest = false
            for i, c in pairs(containers) do
                local chestInv = c.list()
                local containerName = peripheral.getName(c)

                -- Check if this chest already has this item type
                for chestSlot, chestItem in pairs(chestInv) do
                    if chestItem.name == itemName then
                        -- Found a chest with the same item, try to deposit here
                        local moved = interface.pushItems(containerName, slot)

                        if moved > 0 then
                            totalDeposited = totalDeposited + moved
                            itemsMoved = true
                            foundMatchingChest = true
                            break -- Break out of chest slot loop
                        end
                    end
                end

                if foundMatchingChest then break end -- Break out of chest loop if we moved something
            end

            -- If no matching chest found or item still exists, try first available chest
            if not foundMatchingChest then
                -- Refresh inventory in case item was partially moved
                interfaceInv = interface.list()
                if interfaceInv[slot] then -- Item still exists in this slot
                    for i, c in pairs(containers) do
                        local containerName = peripheral.getName(c)
                        local moved = interface.pushItems(containerName, slot)

                        if moved > 0 then
                            totalDeposited = totalDeposited + moved
                            itemsMoved = true
                            break -- Break out of chest loop
                        end
                    end
                end
            end

            if itemsMoved then break end -- Break out of interface slot loop if we moved something
        end
    end

    print("Total deposited:", totalDeposited)
    return totalDeposited
end

return M
