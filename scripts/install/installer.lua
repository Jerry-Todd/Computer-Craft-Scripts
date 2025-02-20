function Write_File(path, data)
    fs.delete(path)

    local file = fs.open(path, "w")

    if file then
        file.write(data) -- Write content to the file
        file.close() -- Close the file
        -- print("File created")
    else
        print("File failed to create")
    end
end

function Github_Download(path, githubPath)
    local url = "https://raw.githubusercontent.com/Jerry-Todd/Computer-Craft-Scripts/main/"
    local cacheBuster = os.epoch("utc") -- Get the current timestamp
    local file = http.get(url .. githubPath .. "?t=" .. cacheBuster)
    if file then
        file = file.readAll()
        -- print("Github / Got file: " .. githubPath)
        Write_File(path, file)
        print(" - " .. path)
    else
        print("Github / Cant get file: " .. githubPath)
    end
end

term.clear()
term.setCursorPos(1, 1)

print("Downloading Scripts")

Github_Download("scripts/digarea.lua", "scripts/digarea.lua")
Github_Download("scripts/treefarm.lua", "scripts/treefarm.lua")

print("Creating update shortcut")

Write_File("update-scripts.lua", "shell.run(\"scripts/testing/installer.lua\")")

term.clear()
term.setCursorPos(1, 1)

print("Download complete.")
print("Update shortcut created.")
print("(update-scripts.lua in root folder)")