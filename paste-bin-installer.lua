function Write_File(path, data)
    fs.delete("installer.lua")

    local file = fs.open(path, "w")

    if file then
        file.write(data) -- Write content to the file
        file.close()     -- Close the file
        print("File created successfully!")
    else
        print("Failed to create the file.")
    end
end

function Github_Download(path, GithubPath)
    local url = "https://raw.githubusercontent.com/Jerry-Todd/Computer-Craft-Scripts/main/"
    local cacheBuster = os.epoch("utc") -- Get the current timestamp
    local data = http.get(url .. GithubPath .. "?t=" .. cacheBuster)
                     .readAll()
    Write_File(GithubPath, data)
end

Github_Download("installer.lua", "installer.lua")

dofile("installer.lua")

fs.delete("installer.lua")