-- pastebin run QyUNCc93
term.clear()
local termWidth, termHeight = term.getSize() -- Get terminal size
-- Create a window for multishell (all lines except the bottom one)
local multishellWindow = window.create(term.native(), 1, 1, termWidth, termHeight - 1)
term.redirect(multishellWindow)

local unityWindow = window.create(term.native(), 1, termHeight, termWidth, 1)
function SetUnityStatus(text)
    local previousTerm = term.redirect(unityWindow)
    term.setBackgroundColor(colors.gray)
    term.clear()
    term.setCursorPos(1, 1)
    term.write("Unity - ")
    term.write(text)
    term.redirect(multishellWindow)
end
SetUnityStatus("Attempting connection")
term.setBackgroundColor(colors.red)
term.setCursorPos(1,1)