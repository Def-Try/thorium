local print = print
local fmt = string.format
local string = string

local isnumber = isnumber
local isstring = isstring
local tostring = tostring

local Msg = Msg
local AddCSLuaFile = AddCSLuaFile
local include = include
local pcall = pcall

module("thorium")

---Thorium version
---@type string
VERSION = "0.1.0"
---Thorium capabilities
---@type table
CAPABILITIES = {}

---Checks if Thorium has capability loaded
---@param capability string capability to check
function HasCapability(capability)
    if not capability then return false end
    return CAPABILITIES[capability] ~= nil
end

---Gets capability version
---@param capability string capability to check version of
---@return string version
function GetCapabilityVersion(capability)
    if not capability then return "0.0.0" end
    local ver = CAPABILITIES[capability]
    if isnumber(ver) then ver = tostring(ver) end
    if not isstring(ver) then ver = "1.0.0" end
    return ver
end

---Loads thorium capability
---@param file string File to load
---@param capability string|nil Register as capability
---@param client boolean|nil Should be sent and executed on client?
---@param cap_ver string|nil Capability version
---@return boolean success Was module loaded successful?
---@return any|string module_or_error Returned value from include, or error string
function LoadCapability(file, capability, client, cap_ver)
    if not file then
        return false, "no file supplied"
    end
    capability = capability or string.GetFileFromFilename(file)
    client = client == nil or client ~= false
    Msg("[THORIUM] Loading capability ", capability, " ver "..tostring(cap_ver)..", file \"", file, "\"...")
    if CLIENT and not client then
        Msg("abort: not supposed to load on client\n")
        return false, "not supposed to load on client"
    end
    if client then AddCSLuaFile(file) end
    local success, err = pcall(function()
        return include(file)
    end)
    if success then
        Msg("OK\n")
        CAPABILITIES[capability] = cap_ver or true
    else
        Msg("error: ", err, "\n")
    end
    return success, err
end

print(fmt("[THORIUM] Loading thorium %s...", VERSION))

LoadCapability("thorium/buffer.lua", "bytebuffer", true, "1.0.0")
LoadCapability("thorium/net.lua", "net", true, "1.0.0")
LoadCapability("thorium/localisation.lua", "locale", true, "1.0.0")
LoadCapability("thorium/random.lua", "random", true, "1.0.0")
LoadCapability("extensions/thorium/math.lua", "ext_math", true, "1.0.0")
LoadCapability("extensions/thorium/file.lua", "ext_file", true, "1.0.0")
LoadCapability("extensions/thorium/print.lua", "ext_print", true, "1.0.0")
LoadCapability("extensions/thorium/color.lua", "ext_color", true, "1.0.0")
LoadCapability("extensions/thorium/nwvars.lua", "ext_nwvar", true, "1.0.0")

printf("[THORIUM] Thorium %s ready!", VERSION)