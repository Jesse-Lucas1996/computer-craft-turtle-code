local args = { ... }

if not args[1] then
    print("Error: Please provide a repository URL.")
    return
end

if not args[2] then
    print("Error: Please provide a destination path.")
    return
end

local zipUrl = args[1] .. "/archive/refs/heads/main.zip"
wget.get(zipUrl, args[2])