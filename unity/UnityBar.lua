function UnityBar()
    while true do
        local previousTerm = term.redirect(statusBar)

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
