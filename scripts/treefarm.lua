
function selectItem(item)
    item = "minecraft:" .. item
    local itemdetail = turtle.getItemDetail()
    if itemdetail ~= nil and itemdetail.name == item then
        return true
    end
    for i = 1, 16, 1 do
        turtle.select(i)
        itemdetail = turtle.getItemDetail()
        if itemdetail ~= nil and itemdetail.name == item then
            return true
        end
    end
    return false
end

function isBlock(block)
    block = "minecraft:" .. block
    local isThere, data = turtle.inspect()
    if block == data.name then
        return true
    end
    return false
end



while (true) do
    repeat
        if selectItem("bone_meal") then
            turtle.place()
        end
    until isBlock("spruce_log")
    height = 0
    while isBlock("spruce_log") do
        turtle.dig()
        if turtle.detectUp() then turtle.digUp() end
        turtle.up()
        height = height + 1
    end
    for i = 1, height, 1 do
        if turtle.detectDown() then turtle.digDown() end
        turtle.down()
    end
    if selectItem("spruce_sapling") then
        turtle.place()
    end
end