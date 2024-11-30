require("thorium")

local gnet = thorium.gnet

if CLIENT then
    -- create a receiver for our message
    gnet.Receive("chat", function(handle, size, from)
        -- handle is NetHandle and is derived from ByteBuffer, so we can use it's methods
        local from = handle:ReadEntity()
        local message = handle:ReadStringNT()
    
        assert(from == LocalPlayer(), "we got a message from somebody else!")
        assert(message == "hello, me!", "we got something else!")
    end)
    return -- we don't do anything on client anymore
end

-- let's send the message!

-- gnet.Start returns a NetHandle. we don't have to send message right away, we can delay it infinitely!
local handle = gnet.Start("chat")
-- NetHandle and is derived from ByteBuffer, so we can use it's methods
handle:WriteEntity(Entity(1))
handle:WriteStringNT("hello, me!")

-- gnet.Send actually sends our message. after that, we should dispose of our handle
-- (to make sure that we don't accidentally corrupt it!)
gnet.Send(handle, Entity(1))

---@diagnostic disable-next-line: cast-local-type
handle = nil
