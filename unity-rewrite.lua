local termWidth, termHeight = term.getSize() -- Get terminal size
local statusBar = window.create(term.native(), 1, termHeight, termWidth, 1)
local terminal = window.create(term.native(), 1, 1, termWidth, termHeight - 1)


term.redirect(terminal)


Unity = coroutine.create(function()
    while true do
        local previousTerm = term.redirect(statusBar)
        term.setBackgroundColor(colors.white)
        term.clear()
        term.redirect(previousTerm)
        coroutine.yield()
    end
end)

coroutine.resume(Unity)