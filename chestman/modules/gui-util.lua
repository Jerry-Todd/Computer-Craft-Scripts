
local M = {}

-- Function to draw a button
function M.drawBox(x, y, width, text, color)

    text = text or ""

    term.setBackgroundColor(color or colors.gray)
    term.setTextColor(colors.white)
    term.setCursorPos(x, y)
    
    -- Draw button background
    local padding = math.floor((width - #text) / 2)
    local buttonText = string.rep(" ", padding) .. text .. string.rep(" ", width - padding - #text)
    term.write(buttonText)
    
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end

-- Function to check if click is within button bounds
function M.isClickInButton(clickX, clickY, buttonX, buttonY, buttonWidth)
    return clickX >= buttonX and clickX < buttonX + buttonWidth and clickY == buttonY
end

function M.seperator(s)
    local w,h = term.getSize()
    print(string.rep('=', w))
end

return M