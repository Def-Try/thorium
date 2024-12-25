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

---Tries to find the addon that owns a file
---@param filepath string
---@param search_legacy boolean|nil Search in legacy addons too? True by default.
---@return string|nil owner Addon that owns the file, or nil if none was found.
function file.WhereIs(filepath, search_legacy)
    search_legacy = search_legacy == nil or search_legacy ~= false
    -- search in workshop addons
    for _,addontable in pairs(engine.GetAddons()) do
        if not file.Exists(filepath, addontable.title) then continue end
        return addontable.title
    end
    if not search_legacy then
        return "unknown"
    end
    -- search in legacy addons
    local _, addons = file.Find("addons/*", "GAME")
    for _,addonname in pairs(addons) do
        if not file.Exists("addons/"..addonname.."/"..filepath, "GAME") then continue end
        return addonname
    end
    return "unknown"
end