local args = {...}
local user = args[1]
local repo = args[2]
local branch = args[3]
local file = args[4]
local out = args[5] or ""

local programName = args[0] or fs.getName(shell.getRunningProgram())

thing = user.."/"..repo.."/"..branch
link = "https://raw.githubusercontent.com/"..thing.."/"

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
        print("Usage: "..programName.." <user> <repo> <branch> <file> [output dir]")
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

local data = {file,false}
get(data)
