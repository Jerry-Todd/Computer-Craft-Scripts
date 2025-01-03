
local termWidth, termHeight = term.getSize() -- Get terminal size
local statusBar = window.create(term.native(), 1, termHeight, termWidth, 1)


statusBar.setBackgroundColor(colors.white)
