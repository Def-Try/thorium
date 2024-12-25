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

local string_lower = string.lower
local string_Split = string.Split
local string_gmatch = string.gmatch
local file_Read = file.Read

local langconvar = GetConVar("gmod_language")

---A better localization module
---@class GLocale
local glocale = {}
thorium.glocale = glocale

local stringtable = {}

function glocale.GetStringTable()
    return stringtable
end

local allowed_symbols = {
    ["a"]=true, ["b"]=true, ["c"]=true, ["d"]=true, ["e"]=true, ["f"]=true,
    ["g"]=true, ["h"]=true, ["i"]=true, ["j"]=true, ["k"]=true, ["l"]=true,
    ["m"]=true, ["n"]=true, ["o"]=true, ["p"]=true, ["q"]=true, ["r"]=true,
    ["s"]=true, ["t"]=true, ["u"]=true, ["v"]=true, ["w"]=true, ["x"]=true,
    ["y"]=true, ["z"]=true, ["0"]=true, ["1"]=true, ["2"]=true, ["3"]=true,
    ["4"]=true, ["5"]=true, ["6"]=true, ["7"]=true, ["8"]=true, ["9"]=true,
    ["_"]=true, ["-"]=true, ["."]=true,
}

---Add a translation string
---@param placeholder string Placeholder
---@param fulltext string Translation string
---@param lang string|nil Language code
function glocale.Add(placeholder, fulltext, lang)
    stringtable[(lang or "UNIVERSAL").."_"..string_lower(placeholder)] = fulltext
end

---Load translation strings from properties file
---@param filepath string Filepath
---@param gamepath string Gamepath
---@param lang string|nil Language code
function glocale.LoadFromFile(filepath, gamepath, lang)
    local text = file_Read(filepath, gamepath)
    if not text then return print(gamepath.."://"..filepath.." contained no language data!") end
    for _, line in pairs(string_Split(text, '\n')) do
        if line[1] == "#" then continue end
        if #line == 0 then continue end
        for k, v in string_gmatch(line, "(.-)=(.-)$") do
            glocale.Add(k, v, lang)
        end
    end
end

---Localize string
---@param text string Text to localize
---@param lang string|nil Language code
---@return string Localized text
function glocale.Localize(text, lang)
    local localstring, building = "", false
    local i = 1
    local localised = ""
    while i <= #text do
        if text[i] == "#" and not (i > 1 and text[i-1] == "#") then
            if building then
                building = false
                localised = localised .. (
                    stringtable[(lang or langconvar:GetString()).."_"..string_lower(localstring)] or
                    stringtable["UNIVERSAL_"..string_lower(localstring)] or
                    "#"..string_lower(localstring))
                localstring = ""
            else
                building = true
                i = i + 1
            end
            continue
        end
        if not building then
            localised = localised .. text[i]
        else
            if allowed_symbols[text[i]] == nil then
                building = false
                localised = localised .. (
                    stringtable[(lang or langconvar:GetString()).."_"..string_lower(localstring)] or
                    stringtable["UNIVERSAL_"..string_lower(localstring)] or
                    "#"..string_lower(localstring)) .. text[i]
                localstring = ""
                i = i + 1
                continue
            end
            localstring = localstring .. text[i]
        end
        i = i + 1
    end
    if building then
        localised = localised .. (
            stringtable[(lang or langconvar:GetString()).."_"..string_lower(localstring)] or
            stringtable["UNIVERSAL_"..string_lower(localstring)] or
            "#"..string_lower(localstring))
    end
    return localised
end

glocale.LoadFromFile("resource/localization/en/community.properties", "GAME")
glocale.LoadFromFile("resource/localization/en/context.properties", "GAME")
glocale.LoadFromFile("resource/localization/en/entities.properties", "GAME")
glocale.LoadFromFile("resource/localization/en/hints.properties", "GAME")
glocale.LoadFromFile("resource/localization/en/main_menu.properties", "GAME")
glocale.LoadFromFile("resource/localization/en/postprocessing.properties", "GAME")
glocale.LoadFromFile("resource/localization/en/spawnmenu.properties", "GAME")
glocale.LoadFromFile("resource/localization/en/tool.properties", "GAME")

local _, langs = file.Find("resource/localization/*", "GAME")
for _, lang in pairs(langs) do
    local files, _ = file.Find("resource/localization/"..lang.."/*", "GAME")
    for _, file_ in pairs(files) do
        glocale.LoadFromFile("resource/localization/"..lang.."/"..file_, "GAME", lang)
    end
end