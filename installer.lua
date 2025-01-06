function Write_File(path, data)
    fs.delete(path)

    local file = fs.open(path, "w")

    if file then
        file.write(data) -- Write content to the file
        file.close() -- Close the file
        print("File created successfully!")
    else
        print("Failed to create the file.")
    end
end

function Github_Download(path, githubPath)
    local url = "https://raw.githubusercontent.com/Jerry-Todd/Computer-Craft-Scripts/main/"
    local cacheBuster = os.epoch("utc") -- Get the current timestamp
    local file = http.get(url .. githubPath .. "?t=" .. cacheBuster)
    if file then
        file = file.readAll()
        Write_File(path, file)
        print(" - " .. path)
    else
        print("Github / Cant get file: " .. githubPath)
    end
end

term.clear()
term.setCursorPos(1, 1)
if fs.isDir("unity") then
    print("Reinstalling Unity")
    print("Removing Unity...")
end
print("downloading Unity")
print("Downloading assets. test")
Write_File("update.lua", 'shell.run("pastebin run myiZqrq6")')
print(" - " .. "update.lua")
Write_File("unity.lua", 'dofile("unity/unity.lua")')
print(" - " .. "unity.lua (shortcut)")
Github_Download("unity/unity.lua", "Unity/unity.lua")
Github_Download("unity/unity.lua", "Unity/unityShell.lua")
Github_Download("unity/unity.lua", "Unity/unityBar.lua")
Github_Download("unity/unity.lua", "Unity/unityWSS.lua")
Github_Download("unity/unity.lua", "Unity/unityAPI.lua")
Github_Download("unity/wss-checker.lua", "Unity/wss-checker.lua")
Github_Download("api-test.lua", "api-test-program.lua")
print("Download complete.")
