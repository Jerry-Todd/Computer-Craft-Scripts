local UnityBar = {}

function UnityBar.run(terminal, termWidth, termHeight)
    while true do
        local previousTerm = term.redirect(terminal)

        term.setBackgroundColor(colors.white)
        term.clear()
        term.setCursorPos(1, termHeight)
        term.setTextColor(colors.black)
        term.write("Unity / " .. Unity.barText)

        term.redirect(previousTerm)

        -- Yield for a short time to prevent excessive CPU usage
        sleep(0.1)
    end
end

return UnityBar
