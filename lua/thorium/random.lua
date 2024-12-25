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

local bit_bxor = bit.bxor
local bit_arshift = bit.arshift
local math_Round = math.Round
local string_format = string.format

---Access point to Random objects
---@class GRandom
local grandom = {}
thorium.grandom = grandom

---@class Random
local random = {seed=os.time()}

---Creates new Random object
---@param seed integer
---@return Random
function grandom.New(seed)
	seed = seed or os.time()
    return random:New(seed)
end

function random:__tostring()
	return string_format("[Random seed=%s]", self:GetSeed())
end

---Creates new Random object
---@param seed integer
---@return Random
function random:New(seed)
    local this = {seed=seed}
    setmetatable(this, self)
    self.__index = self
    return this
end

---Set seed on Random object
---@param seed integer
---@return Random self Object itself, for chaining
function random:SetSeed(seed)
    self.seed = seed
	return self
end

---Get seed of Random object
---@return number
function random:GetSeed()
    return self.seed
end

---Generates random number in range from 0 to 1
---@package
---@return number
function random:RandomFloat()
    local wseed = self:GetSeed() * 747796405 + 2891336453
	local result = (bit_bxor(bit_arshift(wseed, (bit_arshift(wseed, 28) + 4)), wseed)) * 277803737
	result = bit_bxor(bit_arshift(result, 22), result)
	result = result % 4294967295
	self:SetSeed(self:GetSeed() + 1)
	return result / (4294967295 / 2)
end

---Generates random float in range from min to max
---When max is not set, min argument becomes the max, and min is set to 0
---When no arguments are specified, min becomes 0, max becomes 1
---@param min number
---@param max number
---@return number
---@overload fun(max: number): number
---@overload fun(): number
function random:RandFloat(min, max)
	if max == nil then
		if min == nil then
			min, max = 0, 1
		else
			min, max = 0, min
		end
	end
	return self:RandomFloat() * (max - min) + min
end

---Generates random integer in range from min to max
---When max is not set, min argument becomes the max, and min is set to 0
---When no arguments are specified, min becomes 0, max becomes 1
---@param min number
---@param max number
---@return number
---@overload fun(max: number): number
---@overload fun(): number
function random:RandInt(min, max)
	return math_Round(self:RandFloat(min, max))
end