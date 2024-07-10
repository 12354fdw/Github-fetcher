local args = {...}
local user = args[1]
local repo = args[2]
local branch = args[3]
local out = args[4] or ""

local programName = args[0] or fs.getName(shell.getRunningProgram())
local downloaded = {}

local thing
local link

function cleanup()
    for i,v in pairs(downloaded) do
        fs.delete(v)
    end
    print("Usage: "..programName.." <user> <repo> <branch> [output dir]")
end

local s,e = pcall(function()
    thing = user.."/"..repo.."/"..branch
    link = "https://raw.githubusercontent.com/"..thing.."/"
end)

if not s then
    cleanup()
    return
end


function get(data)

    local name = data[1]
    local ok, e = http.checkURL(link..name)
    if not ok then
        print("FAILURE [FILE "..name.." does not exists in the repo!")
        return "FAILURE"
    end

    print("Getting "..name)
    if fs.exists(out.."/"..name) then
        print("WARNING [FILE "..out.."/"..name.." ALREADY EXISTS] OVERWRITING")
    end

    local response = http.get(link..name)
    if not response then
        print("FAILED [HTTP ERROR]")
        return "FAILURE"
    end
    local readed = response.readAll()
    response.close()
    
    local dir = out.."/"..name

    if data[2] == true then
        dir = data[3]
    end

    local write = fs.open(dir,"wb")
    write.write(readed)
    write.close()
    table.insert(downloaded,dir)
end

local what = get({"manifest.lua",false})
if what == "FAILURE" then
    cleanup()
    return
end

local manifest = require(out.."/".."manifest")

print()

for i,v in pairs(manifest) do
    local what = get(v)
    if what == "FAILURE" then
        cleanup()
        return
    end
end

pcall( function () fs.delete(out.."/manifest.lua") end)

print()
print("download complete")
