if not CLIENT then return end -- this is a p2p showcase, don't load on server

hook.Add("ThoriumReady", "MyAddon_ThoriumReady", function()
    local gnet = thorium.gnet

    -- create a receiver for our message. note the "p2p_" addition!
    gnet.Receive("p2p_chat", function(handle, size, from)
        if not from then return end -- if `from` is nil, we got a message from server. discard.

        -- handle is NetHandle and is derived from ByteBuffer, so we can use it's methods
        local message = handle:ReadStringNT()
        
        assert(from == LocalPlayer(), "we got a message from somebody else!")
        assert(message == "hello, me!", "we got something else!")
    end)

    -- let's send the message!

    -- gnet.Start returns a NetHandle. we don't have to send message right away, we can delay it infinitely!
    local handle = gnet.Start("chat")
    -- NetHandle and is derived from ByteBuffer, so we can use it's methods
    handle:WriteStringNT("hello, me!")

    -- gnet.Send actually sends our message. after that, we should dispose of our handle
    -- (to make sure that we don't accidentally corrupt it!)
    gnet.Send(handle, LocalPlayer())

    ---@diagnostic disable-next-line: cast-local-type
    handle = nil
end)
