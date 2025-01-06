function Write_File(path, data)
    fs.delete(path)

    local file = fs.open(path, "w")

    if file then
        file.write(data) -- Write content to the file
        file.close() -- Close the file
        print("File created")
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
        print("Github / Got file: " .. githubPath)
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
Github_Download("unity/unity.lua", "unity/unity.lua")
Github_Download("unity/unity.lua", "unity/unityShell.lua")
Github_Download("unity/unity.lua", "unity/unityBar.lua")
Github_Download("unity/unity.lua", "unity/unityWSS.lua")
Github_Download("unity/unity.lua", "unity/unityAPI.lua")
Github_Download("unity/wss-checker.lua", "unity/wss-checker.lua")
Github_Download("api-test.lua", "api-test-program.lua")
print("Download complete.")
