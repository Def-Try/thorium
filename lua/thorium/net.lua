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

---A better abstraction over default garrysmod net
---@class GNet
local gnet = {}
thorium.gnet = gnet

local string_format = string.format
local net = net
local gbuffer = thorium.gbuffer

local table_GetKeys = table.GetKeys
local math_random = math.random

if SERVER then
    util.AddNetworkString("THORIUM_NETWORK_START")
    util.AddNetworkString("THORIUM_NETWORK_CHUNK")
    util.AddNetworkString("THORIUM_NETWORK_END")
    util.AddNetworkString("THORIUM_NETWORK_WHOLE")
end

local queue_send, queue_recv, receivers = {}, {}, {}

---@class NetHandle: ByteBuffer
---@field message string
---@field TYPETABLE_read table
---@field TYPETABLE_write table
local nethandle = gbuffer.New{message=""}
function nethandle:__tostring()
    return string_format("[NetHandle msg=%q size=%s]", self.message, self:Size())
end

---Writes entity to buffer. Writes 2 bytes.
---@param ent Entity
---@return ByteBuffer self Same buffer, for chaining
function nethandle:WriteEntity(ent)
    return self:WriteUShort(IsValid(ent) and ent:EntIndex() or 0)
end

---Reads entity from buffer. Reads 2 bytes.
---@return Entity ent
function nethandle:ReadEntity(ent)
    return Entity(self:ReadUShort())
end

nethandle.TYPETABLE_read[TYPE_ENTITY] = nethandle.ReadEntity
nethandle.TYPETABLE_write[TYPE_ENTITY] = nethandle.WriteEntity

---@param msg string
---@return NetHandle
local function New(msg)
    local handle = nethandle:New{message=msg}
    ---@cast handle NetHandle
    return handle
end

---Creates new NetHandle
---@param message string Message name
---@return NetHandle
function gnet.Start(message)
    local handle = New(message)
    return handle
end

---Sends a NetHandle over network
---If on client, and target is not set, set to Entity(0) or "SERVER" will send to server.
---If on server, and target is set to "BROADCAST", will broadcast to everyone
---If callbacks table is supplied, function with key "progress" gets called every time that new chunk is transmitted. (arguments are message, handle, and pointer)
---If callbacks table is supplied, function with key "done" gets called once every fragment of message was transmitted. (arguments are message and handle)
---@param handle NetHandle|ByteBuffer NetNandle to send
---@param target Player|Entity|string Target to send the NetHandle to. 
---@param docompress? boolean Allow compression
---@param dochunk? boolean Allow chunking
---@param callbacks? table Callbacks table.
function gnet.Send(handle, target, docompress, dochunk, callbacks)
    if dochunk == nil then dochunk = handle:Size() > 2^15-1 end
    if docompress == nil then docompress = handle:Size() > 2^15-1 end
    handle:Seek(0)
    if not dochunk then
        if handle:Size() > 2^16-1025 then -- 63kb, with safe margin
            error("Too much data to send, consider chunking or compressing")
        end
        net.Start("THORIUM_NETWORK_WHOLE")
            net.WriteString(handle.message)
            net.WriteBool(docompress)
            local data = handle:ReadRAW(handle:Size())
            if docompress then
                data = util.Compress(data)
            end
            net.WriteUInt(#data, 32)
            net.WriteData(data)
            if CLIENT then
                if target ~= nil or target ~= "SERVER" or target ~= game.GetWorld() then
                    ---@cast target Player
                    net.WriteEntity(target)
                end
                net.SendToServer()
            else
                if target ~= "BROADCAST" then
                    ---@cast target Player
                    net.Send(target)
                else
                    net.Broadcast()
                end
            end
        if callbacks and callbacks["done"] then callbacks["done"](handle.message, handle) end
        return
    end
    local transferid = math_random(0, 2^32-1)
    queue_send[transferid] = {handle, target, docompress, callbacks}
    net.Start("THORIUM_NETWORK_START")
        net.WriteUInt(transferid, 16)
        net.WriteString(handle.message)
        net.WriteUInt(handle:Size(), 32)
        net.WriteBool(docompress)
        if CLIENT then
            if target ~= nil or target ~= "SERVER" or target ~= game.GetWorld() then
                ---@cast target Player
                net.WriteEntity(target)
            end
            net.SendToServer()
            return
        end
    if target ~= "BROADCAST" then
        ---@cast target Player
        net.Send(target)
    else
        net.Broadcast()
    end
end

---Adds a net message handler. Only one receiver can be used to receive the message <br>
---Callback arguments: function(handle: NetHandle, size: integer, from: Player|Entity|nil)
---@param message string
---@param callback function
function gnet.Receive(message, callback)
    receivers[message] = callback
end

hook.Add("Think", "THORIUM_NETWORK_PROCESS_SEND_QUEUE", function()
    local keys = table_GetKeys(queue_send)
    local transferid = keys[math_random(1, #keys-1)]
    local item = queue_send[transferid]
    if not item then return end
    local handle, target, compress, callbacks = item[1], item[2], item[3], item[4]

    net.Start("THORIUM_NETWORK_CHUNK")
        net.WriteUInt(transferid, 16)
        local data = handle:ReadRAW(2^15-1) -- about 32kb
        if compress then
            data = util.Compress(data)
        end
        net.WriteUInt(#data, 15)
        net.WriteData(data)
    if CLIENT then net.SendToServer() else
        if target ~= "BROADCAST" then
            ---@cast target Player
            net.Send(target)
        else
            net.Broadcast()
        end
    end
    if callbacks and callbacks["progress"] then
        local noerr, err = pcall(callbacks["progress"], handle.message, handle, handle:Tell())
        if not noerr then
            ErrorNoHalt(err)
        end
    end

    if not handle:EndOfBuffer() then return end
    net.Start("THORIUM_NETWORK_END")
        net.WriteUInt(transferid, 16)
    if CLIENT then net.SendToServer() else
        if target ~= "BROADCAST" then
            ---@cast target Player
            net.Send(target)
        else
            net.Broadcast()
        end
    end
    queue_send[transferid] = nil
    if callbacks and callbacks["done"] then callbacks["done"](handle.message, handle) end
end)

net.Receive("THORIUM_NETWORK_WHOLE", function(len, ply)
    local message = net.ReadString()
    local compressed = net.ReadBool()
    local amount = net.ReadUInt(32)
    local data = net.ReadData(amount)
    local target, from
    if net.BytesLeft() > 0 then
        if SERVER then
            target = net.ReadEntity()
        else
            from = net.ReadEntity()
        end
    end
    if target then
        net.Start("THORIUM_NETWORK_WHOLE")
            net.WriteString(message)
            net.WriteBool(compressed)
            net.WriteUInt(amount, 32)
            net.WriteData(data)
            net.WriteEntity(ply)
        if target ~= "BROADCAST" then
            ---@cast target Player
            net.Send(target)
        else
            net.Broadcast()
        end
        return
    end
    local handle = New(message)
    if compressed then
        data = util.Decompress(data)
    end
    handle:WriteRAW(data)
    handle:Seek(0)
    receivers[((CLIENT and from) and "p2p_" or "")..message](handle, handle:Size(), SERVER and ply or from)
    hook.Run("Thorium_NetworkMessageReceived", handle.message, handle:Size())
end)

net.Receive("THORIUM_NETWORK_START", function(len, ply)
    local transferid = net.ReadUInt(16)
    local message = net.ReadString()
    local size = net.ReadUInt(32)
    local compressed = net.ReadBool()
    local target, from
    if net.BytesLeft() > 0 then
        if SERVER then
            target = net.ReadEntity()
        else
            from = net.ReadEntity()
        end
    end
    queue_recv[transferid] = {message, size, compressed,
                              SERVER and target or nil, SERVER and ply or from}
    if target then
        net.Start("THORIUM_NETWORK_START")
            net.WriteUInt(transferid, 16)
            net.WriteString(message)
            net.WriteUInt(size, 32)
            net.WriteBool(compressed)
            net.WriteEntity(ply)
        if target ~= "BROADCAST" then
            ---@cast target Player
            net.Send(target)
        else
            net.Broadcast()
        end
        return
    end
    queue_recv[transferid][6] = New(message)
    hook.Run("Thorium_NetworkMessageBegin", message, size, transferid)
end)

net.Receive("THORIUM_NETWORK_CHUNK", function(len, ply)
    local transferid = net.ReadUInt(16)
    local item = queue_recv[transferid]
    if not item then return end
    local compressed = item[3]
    local target
    if SERVER then
        target = item[4]
    end
    local amount = net.ReadUInt(15)
    local data = net.ReadData(amount)
    if target then
        net.Start("THORIUM_NETWORK_CHUNK")
            net.WriteUInt(transferid, 16)
            net.WriteUInt(amount, 15)
            net.WriteData(data)
        if target ~= "BROADCAST" then
            ---@cast target Player
            net.Send(target)
        else
            net.Broadcast()
        end
        return
    end
    if compressed then
        data = util.Decompress(data)
    end
    item[6]:WriteRAW(data)
    hook.Run("Thorium_NetworkMessageChunk", item[1], #data, transferid)
end)

net.Receive("THORIUM_NETWORK_END", function(len, ply)
    local transferid = net.ReadUInt(16)
    local item = queue_recv[transferid]
    if not item then return end
    queue_recv[transferid] = nil
    local target
    if SERVER then
        target = item[4]
    end
    if target then
        net.Start("THORIUM_NETWORK_END")
            net.WriteUInt(transferid, 16)
        if target ~= "BROADCAST" then
            ---@cast target Player
            net.Send(target)
        else
            net.Broadcast()
        end
        return
    end
    item[6]:Seek(0)
    receivers[((CLIENT and item[5]) and "p2p_" or "")..item[1]](item[6], item[2], item[5])
    hook.Run("Thorium_NetworkMessageEnd", item[1], transferid)
end)

---A better abstraction over default garrysmod net: compatibility layer.
---Acts like a layer between net-like functions and gnet
---@class GNetCompat
---@field cur_msg_w NetHandle|nil
---@field cur_msg_r NetHandle|nil
local gnet_compat = {cur_msg_w = nil, cur_msg_r = nil}
thorium.gnet_compat = gnet_compat
---@class GNetCompat
local net = gnet_compat

-- there are no unreliable messages in gnet !
function net.Start(message, _)
    if gnet_compat.cur_msg_w then
        ErrorNoHaltWithStack("Discarding already started message "..gnet_compat.cur_msg_w.message..
                             "in favor of new message "..message)
        gnet_compat.cur_msg_w = nil
    end
    gnet_compat.cur_msg_w = gnet.Start(message)
    return true
end

function net.Abort()
    gnet_compat.cur_msg_w = nil
end

function net.Receive(msg, callback)
    gnet.Receive(msg, function(handle, len, from)
        gnet_compat.cur_msg_r = handle
        handle:Seek(0)
        timer.Simple(0, function() gnet_compat.cur_msg_r = nil end)
        callback(len*8, from)
    end)
end

if SERVER then
    function net.Send(ply)
        gnet.Send(gnet_compat.cur_msg_w, ply)
        gnet_compat.cur_msg_w = nil
    end
    function net.SendOmit(ply)
        local players = table.Flip(player.GetAll())
        if isentity(ply) then players[ply] = nil end
        if istable(ply) then for k,v in pairs(ply) do players[v] = nil end end
        net.Send(table.Flip(players))
    end
    function net.SendPAS() error("Not implemented!") end
    function net.SendPVS() error("Not implemented!") end
    function net.Broadcast() net.Send("BROADCAST") end
end
if CLIENT then
    function net.SendToServer(ply)
        gnet.Send(gnet_compat.cur_msg_w, "SERVER")
        gnet_compat.cur_msg_w = nil
    end
end

function net.ReadHeader() error("GNet doesn't have headers!") end

function net.ReadBit() return gnet_compat.cur_msg_r:ReadBool() and 1 or 0 end
function net.WriteBit(bit) gnet_compat.cur_msg_w:WriteBool(bit == 1) end

function net.ReadBool() return gnet_compat.cur_msg_r:ReadBool() end
function net.WriteBool(bool) gnet_compat.cur_msg_w:WriteBool(bool) end

function net.ReadColor() return gnet_compat.cur_msg_r:ReadColor() end
function net.WriteColor(clr) gnet_compat.cur_msg_w:WriteColor(clr) end

function net.ReadData(n) return gnet_compat.cur_msg_r:ReadRAW(n) end
function net.WriteData(d) gnet_compat.cur_msg_w:WriteRAW(d) end

function net.ReadDouble() return gnet_compat.cur_msg_r:ReadDouble() end
function net.WriteDouble(d) gnet_compat.cur_msg_w:WriteDouble(d) end

function net.ReadFloat() return gnet_compat.cur_msg_r:ReadFloat() end
function net.WriteFloat(d) gnet_compat.cur_msg_w:WriteFloat(d) end

function net.ReadEntity() return gnet_compat.cur_msg_r:ReadEntity() end
function net.WriteEntity(d) gnet_compat.cur_msg_w:WriteEntity(d) end

function net.ReadInt(bits)
    if bits <= 8 then return gnet_compat.cur_msg_r:ReadByte() end
    if bits <= 16 then return gnet_compat.cur_msg_r:ReadShort() end
    return gnet_compat.cur_msg_r:ReadInt()
end
function net.WriteInt(d, bits)
    if bits <= 8 then return gnet_compat.cur_msg_w:WriteByte(d) end
    if bits <= 16 then return gnet_compat.cur_msg_w:WriteShort(d) end
    return gnet_compat.cur_msg_w:WriteInt(d)
end

function net.ReadUInt(bits)
    if bits <= 8 then return gnet_compat.cur_msg_r:ReadUByte() end
    if bits <= 16 then return gnet_compat.cur_msg_r:ReadUShort() end
    return gnet_compat.cur_msg_r:ReadUInt()
end
function net.WriteUInt(d, bits)
    if bits <= 8 then return gnet_compat.cur_msg_w:WriteUByte(d) end
    if bits <= 16 then return gnet_compat.cur_msg_w:WriteUShort(d) end
    return gnet_compat.cur_msg_w:WriteUInt(d)
end

function net.ReadMatrix() error("Not implemented!") end
function net.WriteMatrix(d) error("Not implemented!") end

function net.ReadVector() return gnet_compat.cur_msg_r:ReadVector() end
function net.WriteVector(d) gnet_compat.cur_msg_w:WriteVector(d) end

function net.ReadNormal() return net.ReadVector():GetNormalized() end
function net.WriteNormal(d) net.WriteVector(d) end

function net.ReadPlayer() return net.ReadEntity() end
function net.WritePlayer(d) net.WriteEntity(d) end

function net.ReadString() return gnet_compat.cur_msg_r:ReadStringNT() end
function net.WriteString(d) gnet_compat.cur_msg_w:WriteStringNT(d) end

function net.ReadTable() return gnet_compat.cur_msg_r:ReadTable() end
function net.WriteTable(d) gnet_compat.cur_msg_w:WriteTable(d) end

function net.ReadType() return gnet_compat.cur_msg_r:ReadType() end
function net.WriteType(d) gnet_compat.cur_msg_w:WriteType(d) end

function net.WriteUInt64() error("Not implemented!") end
function net.ReadUInt64() error("Not implemented!") end

function net.BytesLeft()
    if not gnet_compat.cur_msg_r then return nil, nil end
    return 1 + gnet_compat.cur_msg_r:Size(), 6 + gnet_compat.cur_msg_r:Size()*8
end

function net.BytesWritten()
    if not gnet_compat.cur_msg_w then return nil, nil end
    return 3 + gnet_compat.cur_msg_w:Size(), 24 + gnet_compat.cur_msg_w:Size()*8
end

net.WriteVars = nethandle.TYPETABLE_write
net.ReadVars = nethandle.TYPETABLE_read