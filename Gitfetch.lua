local args = {...}
local user = args[1]
local repo = args[2]
local branch = args[3]
local out = args[4] or ""

local thing = user.."/"..repo.."/"..branch
local link = "https://raw.githubusercontent.com/"..thing.."/"

local s = shell.run("wget",link.."manifest.lua","manifest_"..thing)

if not s then
    print("repo does not exists or the repo does not have manifest")
    return
end

local manifest = require("manifest_"..thing)

for i,v in pairs(manifest) do
    print("Getting "..v)
    shell.run("wget",link..v,out.."/"..v)
end

print()
print("download complete")
