function SelectTreeItem(item_name)
    local item = turtle.getItemDetail()
    if item and string.sub(item.name, -(#item_name)) == item_name then
        return true
    end
    for i = 1, 16, 1 do
        turtle.select(i)
        item = turtle.getItemDetail()
        if item and string.sub(item.name, -(#item_name)) == item_name then
            return true
        end
    end
    return false
end

function IsLog()
    local isThere, data = turtle.inspect()
    if isThere and string.sub(data.name, -4) == "_log" then
        return true
    end
    return false
end

-- function Contains(list, value)
--     for _, v in ipairs(list) do
--         if v == value then
--             return true
--         end
--     end
--     return false
-- end

local height
while (true) do
    repeat
        if SelectTreeItem("meal") then
            turtle.place()
        end
    until IsLog()
    height = 0
    while IsLog() do
        turtle.dig()
        if turtle.detectUp() then turtle.digUp() end
        turtle.up()
        height = height + 1
    end
    for i = 1, height, 1 do
        if turtle.detectDown() then turtle.digDown() end
        turtle.down()
    end
    if SelectTreeItem("sapling") then
        turtle.place()
    end
end
