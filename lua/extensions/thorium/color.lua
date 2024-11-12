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

local math_Round = math.Round
local math_Clamp = math.Clamp
local string_format = string.format
local string_sub = string.sub

local COLOR = FindMetaTable("Color")
---Color utilities
---@class GColor
local color = {}
thorium.color = color
color.SERVER = Color(156, 241, 255, 200)
color.CLIENT = Color(255, 241, 122, 200)
color.MENU = Color(100, 220, 100, 200)
color.SERVER_ERR = Color(136, 221, 255, 200)
color.CLIENT_ERR = Color(255, 221, 102, 200)
color.MENU_ERR = Color(120, 220, 100, 200)
color.REALM = SERVER and color.SERVER or CLIENT and color.CLIENT or MENU_DLL and color.MENU

---Converts color to a luminance - how "bright" color is.
---@return number
function COLOR:ToLuminance()
    return math_Round(0.2126 * self.r + 0.7152 * self.g + 0.0722 * self.b)
end

---Converts color into a hex string
---@return string
function COLOR:ToHex()
    return "#"..(self.a == 255 and string_format("%02X%02X%02X", self.r, self.g, self.b) or
                 string_format("%02X%02X%02X%02X", self.r, self.g, self.b, self.a))
end

---Create color from a hex string
---@param hexstring string
---@return Color
function color.FromHex(hexstring)
    if #hexstring ~= 6 and #hexstring ~= 8 and hexstring[1] ~= "#" then error("Expected hexstring, got \""..hexstring.."\"") end
    if hexstring[1] == "#" then hexstring = string_sub(hexstring, 2, 6) end
    local r, g, b, a = tonumber(string_sub(hexstring, 1, 2), 16) or 0,
                       tonumber(string_sub(hexstring, 3, 4), 16) or 0,
                       tonumber(string_sub(hexstring, 5, 6), 16) or 0, 255
    if #hexstring == 8 then
        a = tonumber(string_sub(hexstring, 7, 8), 16) or 255
    end
    return Color(math_Round(r), math_Round(g), math_Round(b), math_Round(a))
end

---Converts color to a grayscale
---@return Color
function COLOR:ToGrayscale()
    local n = math_Clamp(math_Round(self.r * .299 + self.g * .587 + self.b * .114), 0, 255)
    return Color(n,n,n)
end

---Inverts the color
---@param invert_alpha boolean Invert alpha channel as well?
---@return Color
function COLOR:Invert(invert_alpha)
    return Color(255 - self.r, 255 - self.g, 255 - self.b, invert_alpha and 255 - self.a or self.a)
end

function COLOR:SetBrightness(bright)
    local h, s, l = ColorToHSL(self)
	l = math_Clamp(bright / 255, 0, 1)
	return HSLToColor(h, s, l)
end