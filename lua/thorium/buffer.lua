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

local type = type
local assert = assert
local setmetatable = setmetatable
local math_floor = math.floor
local string_char = string.char
local string_byte = string.byte
local string_sub = string.sub
local string_format = string.format

local math_frexp = math.frexp
local math_ldexp = math.ldexp

local bit_band = bit.band

local Vector = Vector
local Angle = Angle
local Color = Color

---Access point to BytBuffer objects
---@class gbuffer
local gbuffer = {}
thorium.gbuffer = gbuffer

---Class used to read and write binary data
---@class ByteBuffer
---@field chunks table<string>
---@field chunk_size integer
---@field size integer
---@field pointer integer
---@field TYPETABLE_read table
---@field TYPETABLE_write table
local buffer = {
				size=0, pointer=0,
				TYPETABLE_read={}, TYPETABLE_write={},
				chunk_size=1024
			   }

local function expect(arg, typ)
	assert(type(arg)==typ, "expected "..typ..", got "..type(arg))
end

local function grab_byte(v)
	return math_floor(v / 256), string_char(math_floor(v) % 256)
end

---Creates new ByteBuffer
---@param o? table Optional, table to base ByteBuffer on
---@return ByteBuffer
function gbuffer.New(o)
	return buffer:New(o)
end

---Creates new ByteBuffer
---@param this? table Optional, table to base ByteBuffer on
---@return ByteBuffer
function buffer:New(this)
	this = this or {}
    setmetatable(this, self)
	self.__index = self
	this.chunks = {""}
    return this
end

---@return string
function buffer:__tostring()
    return string_format("[Buffer size=%s]", self:Size())
end

-- buffer:ReadRAW and buffer:WriteRAW generously provided by today's sponsor:
--     chatgpt! 

---Appends raw data (string) to buffer.
---@param data string Data to write to buffer
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteRAW(data)
    local data_length = #data
    local offset = 1
    while offset <= data_length do
        local space_in_last_chunk = self.chunk_size
        if #self.chunks > 0 then
            space_in_last_chunk = self.chunk_size - #self.chunks[#self.chunks]
        end

        local write_size = math.min(data_length - offset + 1, space_in_last_chunk)
        local chunk = string.sub(data, offset, offset + write_size - 1)

        if #self.chunks == 0 or #self.chunks[#self.chunks] == self.chunk_size then
            table.insert(self.chunks, chunk)
        else
            self.chunks[#self.chunks] = self.chunks[#self.chunks] .. chunk
        end

        self.size = self.size + write_size
        offset = offset + write_size
    end
	return self
end

---Reads raw data (string) from buffer
---@param amount integer How much bytes to read
---@return string data Data that has been read
function buffer:ReadRAW(amount)
    if self.size == 0 or self.pointer > self.size then
        return ""
    end

    local data = ""
    local remaining = amount
    local chunk_index = 1  -- Start at the first chunk
    local chunk_offset = 0 -- Offset within the chunk

    -- Figure out which chunk the pointer is currently in and its offset
    local current_pointer = self.pointer
    for i, chunk in ipairs(self.chunks) do
        local chunk_length = #chunk
        if current_pointer <= chunk_length then
            chunk_index = i
            chunk_offset = current_pointer - 1
            break
        else
            current_pointer = current_pointer - chunk_length
        end
    end


    while remaining > 0 and chunk_index <= #self.chunks do
        local chunk = self.chunks[chunk_index]
        local chunk_length = #chunk
        local read_from_chunk = math.min(remaining, chunk_length - chunk_offset) -- how much to read from current chunk

        data = data .. string.sub(chunk, chunk_offset + 1, chunk_offset + read_from_chunk)

        remaining = remaining - read_from_chunk
        self.pointer = self.pointer + read_from_chunk -- Move the pointer

        chunk_index = chunk_index + 1
        chunk_offset = 0
    end

    return data
end

---Seeks (moves pointer) to a position in buffer.
---On overflow goes over.
---@param seek_to integer Where to seek
---@return ByteBuffer self Same buffer, for chaining
function buffer:Seek(seek_to)
	expect(seek_to, "number")

	self.pointer = seek_to % self.size
	return self
end

---Tell the position of pointer in buffer
---@return integer position Pointer position in buffer
function buffer:Tell()
	return self.pointer
end

---Get size of buffer
---@return integer size Buffer size
function buffer:Size()
    return self.size
end

---@return integer size Buffer size
function buffer:__len()
    return self:Size()
end

---Returns whether we are at the end of buffer or not
---@return boolean endofbuffer Are we at the end of buffer
function buffer:EndOfBuffer()
    return self:Tell() > self:Size()
end

---Skips some amount of bytes, same as buffer:Seek(buffer:Tell()+bytes)
---@param bytes integer How much bytes to skip
---@return ByteBuffer self Same buffer, for chaining
function buffer:Skip(bytes)
    self:Seek(self:Tell() + bytes)
	return self
end

---Clears buffer, removing all data from it
---@return ByteBuffer self Same buffer, for chaining
function buffer:Clear()
    self.chunks = {}
    self.size = 0
    self.pointer = 0
	return self
end

-- read/write

---Writes a boolean. Writes 1 byte
---@param bool boolean
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteBool(bool)
    expect(bool, "boolean")
    return self:WriteRAW(bool and "\1" or "\0")
end

---Reads a boolean. Reads 1 byte
---@return boolean bool
function buffer:ReadBool()
    return self:ReadRAW(1) ~= "\0"
end

buffer.TYPETABLE_read[TYPE_BOOL] = buffer.ReadBool
buffer.TYPETABLE_write[TYPE_BOOL] = buffer.WriteBool

---Writes unsigned byte. Writes 1 byte
---@param num integer
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteUByte(num)
	expect(num, "number")
	assert(num >= 0 and num < 256 and math_floor(num) == num, num.." is not a valid UByte")

	return self:WriteRAW(string_char(num))
end

---Reads unsigned byte. Reads 1 byte
---@return integer num
function buffer:ReadUByte()
	local bytes = self:ReadRAW(1)
	return string_byte(bytes)
end

---Writes unsigned short. Writes 2 bytes
---@param num integer
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteUShort(num)
	expect(num, "number")
	assert(num >= 0 and num < 65536 and math_floor(num) == num, num.." is not a valid UShort")

	return self:WriteRAW(string_char(math_floor(num / 256))..
                		 string_char(math_floor(num % 256)))
end

---Reads unsigned short. Reads 2 bytes
---@return integer num
function buffer:ReadUShort()
	local bytes = self:ReadRAW(2)
	local n1, n2 = string_byte(bytes, 1, 2)
	return n1*256+n2
end

---Writes unsigned integer. Writes 4 bytes
---@param num integer
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteUInt(num)
	expect(num, "number")
	assert(num >= 0 and num < 4294967296 and math_floor(num) == num, num.." is not a valid UInt")

	return self:WriteRAW(string_char(math_floor(num / 256 / 256 / 256))..
                 		 string_char(math_floor(num / 256 / 256 % 256))..
                		 string_char(math_floor(num / 256 % 256))..
                		 string_char(math_floor(num % 256)))
end

---Reads unsigned integer. Reads 4 bytes
---@return integer num
function buffer:ReadUInt()
	local bytes = self:ReadRAW(4)
	local n1, n2, n3, n4 = string_byte(bytes, 1, 4)
	return n1*256*256*256+n2*256*256+n3*256+n4
end

---Writes signed byte. Writes 1 byte
---@param num integer
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteByte(num)
	expect(num, "number")
	assert(num >= -128 and num < 128 and math_floor(num) == num, num.." is not a valid Byte")

	num = num + 128
	return self:WriteUByte(num)
end

---Reads signed byte. Reads 1 byte
---@return integer num
function buffer:ReadByte()
	return self:ReadUByte() - 128
end

---Writes signed short. Writes 2 bytes
---@param num integer
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteShort(num)
	expect(num, "number")
	assert(num >= -32768 and num < 32768 and math_floor(num) == num, num.." is not a valid Short")

	num = num + 32768
	return self:WriteUShort(num)
end

---Reads signed short. Reads 2 bytes
---@return integer num
function buffer:ReadShort()
	return self:ReadUShort() - 32768
end

---Writes signed integer. Writes 4 bytes
---@param num integer
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteInt(num)
	expect(num, "number")
	assert(num >= -2147483648 and num < 2147483648 and math_floor(num) == num, num.." is not a valid Int")

	num = num + 2147483648
	return self:WriteUInt(num)
end

---Reads signed integer. Reads 4 bytes
---@return integer num
function buffer:ReadInt()
	return self:ReadUInt() - 2147483648
end


---Writes null terminated string. Writes #str + 1 bytes
---@param str string
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteStringNT(str)
    expect(str, "string")
    return self:WriteRAW(str.."\0")
end

---Reads null terminated string. Reads #str + 1 bytes
---@return string str
function buffer:ReadStringNT()
    local str = ""
    local char = self:ReadRAW(1)
    while char ~= "\0" and not self:EndOfBuffer() do
        str = str .. char
        char = self:ReadRAW(1)
    end
    return str
end

buffer.TYPETABLE_read[TYPE_STRING] = buffer.ReadStringNT
buffer.TYPETABLE_write[TYPE_STRING] = buffer.WriteStringNT

---Writes length prefixed string. Writes #str + 2 bytes
---@param str string
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteStringLP(str)
    expect(str, "string")
    assert(#str <= 4294967295, "string is too long (>=4294967296)")
    return self:WriteUInt(#str):WriteRAW(str)
end

---Reads length prefixed string. Reads #str + 2 bytes
---@return string str
function buffer:ReadStringLP()
    return self:ReadRAW(self:ReadUInt())
end

---Writes single-precision float. Writes 4 bytes
---@param x number
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteFloat(x)
	expect(x, "number")
	local sign = 0
	if x < 0 then
 		sign = 1;
		x = -x
	end
	local mantissa, exponent = math_frexp(x)
	if x == 0 then
		mantissa = 0;
		exponent = 0
	else
		mantissa = (mantissa * 2 - 1) * 8388608
		exponent = exponent + 126
	end
	local v, byte = "", nil
	x, byte = grab_byte(mantissa); v = v..byte
	x, byte = grab_byte(x); v = v..byte
	x, byte = grab_byte(exponent * 128 + x); v = v..byte
	x, byte = grab_byte(sign * 128 + x); v = v..byte
	return self:WriteRAW(v)
end

---Reads single-precision float. Reads 4 bytes
---@return number x
function buffer:ReadFloat()
	local x = self:ReadRAW(4)

	local sign = 1
	local mantissa = string_byte(x, 3) % 128
	for i=2, 1, -1 do
		mantissa = mantissa * 256 + string_byte(x, i)
	end
	if string_byte(x, 4) > 127 then
		sign = -1
	end
	local exponent = (string_byte(x, 4) % 128) * 2 + math_floor(string_byte(x, 3) / 128)
	if exponent == 0 then
		return 0
	end
	mantissa = (math_ldexp(mantissa, -23) + 1) * sign
	return math_ldexp(mantissa, exponent - 127)
end

---Writes double-precision float. Writes 8 bytes
---@param x number
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteDouble(x)
	expect(x, "number")

	local sign = 0
	if x < 0 then 
		sign = 1; 
		x = -x 
	end
	local mantissa, exponent = math_frexp(x)
	if x == 0 then -- zero
		mantissa, exponent = 0, 0
	else
		mantissa = (mantissa * 2 - 1) * 4503599627370496 
		exponent = exponent + 1022
	end
	local v, byte = "", nil
	x = mantissa
	for i = 1,6 do
		x, byte = grab_byte(x); v = v..byte
	end
	x, byte = grab_byte(exponent * 16 + x); v = v..byte
	x, byte = grab_byte(sign * 128 + x); v = v..byte

	return self:WriteRAW(v)
end

---Reads double-precision float. Reads 8 bytes
---@return number x
function buffer:ReadDouble()
	local x = self:ReadRAW(8)

	local sign = 1
	local mantissa = string_byte(x, 7) % 16
	for i = 6, 1, -1 do 
		mantissa = mantissa * 256 + string_byte(x, i)
	end
	if string_byte(x, 8) > 127 then
		sign = -1
	end
	local exponent = (string_byte(x, 8) % 128) * 16 + math_floor(string_byte(x, 7) / 16)
	if exponent == 0 then 
		return 0 
	end
	mantissa = (math_ldexp(mantissa, -52) + 1) * sign
	return math_ldexp(mantissa, exponent - 1023)
end

buffer.TYPETABLE_read[TYPE_NUMBER] = buffer.ReadDouble
buffer.TYPETABLE_write[TYPE_NUMBER] = buffer.WriteDouble

---Writes vector. Writes 12 bytes
---@param vec Vector
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteVector(vec)
	expect(vec, "Vector")

	return self:WriteFloat(vec.x):WriteFloat(vec.y):WriteFloat(vec.z)
end

---Reads vector. Reads 12 bytes
---@return Vector vec
function buffer:ReadVector()
	return Vector(self:ReadFloat(), self:ReadFloat(), self:ReadFloat())
end

buffer.TYPETABLE_read[TYPE_VECTOR] = buffer.ReadVector
buffer.TYPETABLE_write[TYPE_VECTOR] = buffer.WriteVector

---Writes angle. Writes 12 bytes
---@param ang Angle
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteAngle(ang)
	expect(ang, "Angle")

	return self:WriteFloat(ang.p):WriteFloat(ang.y):WriteFloat(ang.r)
end

---Reads angle. Reads 12 bytes
---@return Angle ang
function buffer:ReadAngle()
	return Angle(self:ReadFloat(), self:ReadFloat(), self:ReadFloat())
end

buffer.TYPETABLE_read[TYPE_ANGLE] = buffer.ReadAngle
buffer.TYPETABLE_write[TYPE_ANGLE] = buffer.WriteAngle

---Writes color. Writes 4 bytes
---@param clr Color
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteColor(clr)
	assert(IsColor(clr), "expected Color, got "..type(clr))
	return self:WriteUByte(clr.r):WriteUByte(clr.g):WriteUByte(clr.b):WriteUByte(clr.a)
end

---Reads color. Reads 4 bytes
---@return Color clr
function buffer:ReadColor()
	return Color(self:ReadUByte(), self:ReadUByte(), self:ReadUByte(), self:ReadUByte())
end

buffer.TYPETABLE_read[TYPE_COLOR] = buffer.ReadColor
buffer.TYPETABLE_write[TYPE_COLOR] = buffer.WriteColor

---Writes VarInt. Writes variable amount of bytes
---@param num integer
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteVarInt(num)
    expect(num, "number")
	assert(math_floor(num) == num, num.." is not a valid VarInt")
    while true do
        local byte = bit_band(num, 0x7f)
        num = math_floor(num / 2^7)
        if num == 0 then
            self:WriteUByte(byte)
            break
        else
            self:WriteUByte(byte + 0x80)
        end
    end
	return self
end

---Reads VarInt. Reads variable amount of bytes
---@return integer num
function buffer:ReadVarInt()
    local value = 0
    local shift = 0
    while true do
        local byte = self:ReadUByte()
        value = value + (bit_band(byte, 0x7f) * 2^shift)
        shift = shift + 7
        if bit_band(byte, 0x80) == 0 then
            break
        end
    end
    return value
end

-- to keep gmod happy
buffer.TYPETABLE_read[TYPE_NIL] = function(s, v) return nil end
buffer.TYPETABLE_write[TYPE_NIL] =  function(s) return s end

---Attempts to write a variable type. Writes variable amount of bytes
---@param v any
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteType(v)
	local typeid = TypeID(v)
	if IsColor(v) then typeid = TYPE_COLOR end
	if not self.TYPETABLE_write[typeid] then
		error(type(v).." can not be written to buffer (unknown typeid)")
	end
	return self.TYPETABLE_write[typeid](self:WriteUByte(typeid), v)
end

---Attempts to read a variable type. Reads variable amount of bytes
---@return any v
function buffer:ReadType()
	return self.TYPETABLE_read[self:ReadUByte()](self)
end

---Writes table to buffer. Writes variable amount of bytes
---@param tbl table
---@return ByteBuffer self Same buffer, for chaining
function buffer:WriteTable(tbl)
	if table.IsSequential(tbl) then
		self:WriteBool(true)
		self:WriteVarInt(#tbl)
		for i=1,#tbl do
			self:WriteType(tbl[i])
		end
		return self
	end
	self:WriteBool(false)
	self:WriteVarInt(#tbl:GetKeys())
	for k,v in pairs(tbl) do
		self:WriteType(k)
		self:WriteType(v)
	end
	return self
end

---Reads table from buffer. Reads variable amount of bytes
---@return table tbl
function buffer:ReadTable()
	local tbl = {}
	if self:ReadBool() then
		local lim = self:ReadVarInt()
		for i=1,lim do
			tbl[#tbl+1] = self:ReadType()
		end
		return tbl
	end
	local lim = self:ReadVarInt()
	for i=1,lim do
		tbl[self:ReadType()] = self:ReadType()
	end
	return tbl
end

buffer.TYPETABLE_read[TYPE_TABLE] = buffer.ReadTable
buffer.TYPETABLE_write[TYPE_TABLE] = buffer.WriteTable

---Reads a file into a ByteBuffer
---@param path string
---@param gamepath string
---@return ByteBuffer|nil ByteBuffer on success, or nil
function gbuffer.ReadFromFile(path, gamepath)
	if not file.Exists(path, gamepath) then return end
	local buf = gbuffer.New()
	buf:WriteRAW(file.Read(path, gamepath))
	return buf
end

---Writes ByteBuffer into a file
---@param path string
function buffer:WriteToFile(path)
	file.Write(path, "")
	local id = math.random(100000, 999999)
	self:Seek(0)
	--[[
	timer.Create("THORIUM_FileWrite_"..id, 0, 0, function()
		if self:EndOfBuffer() then
			timer.Remove("THORIUM_FileWrite_"..id)
			return
		end
		file.Append(path, self:ReadRAW(1024))
	end)
	]]
	while not self:EndOfBuffer() do
		file.Append(path, self:ReadRAW(1024))
	end
end