--[[
   [ Copyright (c) 2024 googer_
   [
   [ Permission is hereby granted, free of charge, to any person obtaining a copy
   [ of this software and associated documentation files (the "Software"), to deal
   [ in the Software without restriction, including without limitation the rights
   [ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   [ copies of the Software, and to permit persons to whom the Software is
   [ furnished to do so, subject to the following conditions:
   [
   [ The above copyright notice and this permission notice shall be included in all
   [ copies or substantial portions of the Software.
   [
   [ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   [ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   [ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   [ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   [ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   [ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   [ SOFTWARE.
   []]

-- COPYRIGHT NOTICE CODE BEGIN
print("[THORIUM] Copyright 2024, googer_")
print("[THORIUM] By using this library server owner has agreed to the License")
-- COPYRIGHT NOTICE CODE END

AddCSLuaFile()

---Thorium
---@class Thorium
_G.thorium = {}

---Thorium version
---@type string
_G.thorium.VERSION = "0.1.0"
---Thorium capabilities
---@type table
_G.thorium.CAPABILITIES = {}

---Checks if Thorium has capability loaded
---@param capability string capability to check
function _G.thorium.HasCapability(capability)
    if not capability then return false end
    return _G.thorium.CAPABILITIES[capability] ~= nil
end

---Gets capability version
---@param capability string capability to check version of
---@return string version
function _G.thorium.GetCapabilityVersion(capability)
    if not capability then return "0.0.0" end
    local ver = _G.thorium.CAPABILITIES[capability]
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
function _G.thorium.LoadCapability(file, capability, client, cap_ver)
    if not file then
        return false, "no file supplied"
    end
    capability = capability or string.GetFileFromFilename(file)
    client = client == nil or client ~= false
    Msg("[THORIUM] Loading capability ", capability, " ver "..tostring(cap_ver)..", file \"", file, "\"...")
    if CLIENT and not client then
        Msg("abort: not supposed to laod on client\n")
        return false, "not supposed to load on client"
    end
    if client then AddCSLuaFile(file) end
    local success, err = pcall(function()
        return include(file)
    end)
    if success then
        Msg("OK\n")
        _G.thorium.CAPABILITIES[capability] = cap_ver or true
    else
        Msg("error: ", err, "\n")
    end
    return success, err
end

print(string.format("[THORIUM] Loading thorium %s...", _G.thorium.VERSION))

_G.thorium.LoadCapability("thorium/buffer.lua", "bytebuffer", true, "1.0.0")
_G.thorium.LoadCapability("thorium/net.lua", "net", true, "1.0.0")
_G.thorium.LoadCapability("thorium/localisation.lua", "locale", true, "1.0.0")
_G.thorium.LoadCapability("thorium/random.lua", "random", true, "1.0.0")
_G.thorium.LoadCapability("extensions/thorium/math.lua", "ext_math", true, "1.0.0")
_G.thorium.LoadCapability("extensions/thorium/file.lua", "ext_file", true, "1.0.0")
_G.thorium.LoadCapability("extensions/thorium/print.lua", "ext_print", true, "1.0.0")
_G.thorium.LoadCapability("extensions/thorium/color.lua", "ext_color", true, "1.0.0")
_G.thorium.LoadCapability("extensions/thorium/nwvars.lua", "ext_nwvar", true, "1.0.0")

hook.Run("ThoriumReady")
printf("[THORIUM] Thorium %s ready!", _G.thorium.VERSION)