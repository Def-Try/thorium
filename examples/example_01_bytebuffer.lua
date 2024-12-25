require("thorium")

local gbuffer = thorium.gbuffer

-- create our buffer
local buffer = gbuffer.New()
-- write some data
buffer:WriteBool(true) -- functions that you don't expect to return anything return
        :WriteUByte(128) -- bytebuffer itself. this allows us to chain calls like this
        :WriteDouble(123.456)
        :WriteStringNT("hello world!") -- StringNT = Null Terminated String
        :WriteStringLP("\0\1\2\3\4") --   StringLP = Length Prefixed String
        :WriteVarInt(498216389) -- VarInt = Variable Int. Writes as much bytes as it needs to.

-- let's now verify our buffer data

buffer:Seek(0) -- first we seek to the buffer beginning
-- now we read
assert(buffer:ReadBool() == true,               "buffer data is wrong!")
assert(buffer:ReadUByte() == 128,               "buffer data is wrong!")
assert(buffer:ReadDouble() == 123.456,          "buffer data is wrong!")
assert(buffer:ReadStringNT() == "hello world!", "buffer data is wrong!")
assert(buffer:ReadStringLP() == "\0\1\2\3\4",   "buffer data is wrong!")
assert(buffer:ReadVarInt() == 498216389,        "buffer data is wrong!")