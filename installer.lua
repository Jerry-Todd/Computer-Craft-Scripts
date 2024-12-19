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

function Github_Download(path, filename)
    local file = http.get("https://raw.githubusercontent.com/Jerry-Todd/Computer-Craft-Scripts/main/" .. filename).readAll()
    Write_File("filename", file)
end

term.clear()
term.setCursorPos(1,1)
print("Downloading Unity assets.")
-- Github_Download()