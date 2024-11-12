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

local ENTITY = FindMetaTable("Entity")
---NetWork Variables utilities
---@class GNWVars
local nwvars = {}
thorium.nwvars = nwvars

---Sets NW var on entity
---@param key any
---@param var any
function ENTITY:SetGNWVar(key, var)
    self.thorium_nwvars = self.thorium_nwvars or {}
    self.thorium_nwvars_callbacks = self.thorium_nwvars_callbacks or {}

    local old = self.thorium_nwvars[key]
    self.thorium_nwvars[key] = var
    if self.thorium_nwvars_callbacks[key] then
        self.thorium_nwvars_callbacks[key](self, key, old, var)
    end

    if CLIENT then
        return
    end

    thorium.gnet.Send(
        thorium.gnet.Start("GNWVar")
            :WriteEntity(self)
            :WriteType(key)
            :WriteType(var),
        "BROADCAST"
    )
end

thorium.gnet.Receive("GNWVar", function(handle, _, from)
    if IsValid(from) then return end
    local ent = handle:ReadEntity()
    local key = handle:ReadType()
    local var = handle:ReadType()
    local old = ent.thorium_nwvars[key]
    ent.thorium_nwvars[key] = var
    if ent.thorium_nwvars_callbacks[key] then
        ent.thorium_nwvars_callbacks[key](ent, key, old, var)
    end
end)

---Gets NW var from entity
---@param key any
---@param default any
---@return any
function ENTITY:GetGNWVar(key, default)
    self.thorium_nwvars = self.thorium_nwvars or {}
    return self.thorium_nwvars[key] or default
end

---Sets a function to be called when the NW var changes
---Callback arguments: function(ent: Entity, key: any, old: any, new: any)
---@param key any
---@param callback function
function ENTITY:SetGNWVarCallback(key, callback)
    self.thorium_nwvars_callbacks = self.thorium_nwvars_callbacks or {}
    self.thorium_nwvars_callbacks[key] = callback
end