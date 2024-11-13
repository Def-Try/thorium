hook.Add("ThoriumReady", "MyAddon_ThoriumReady", function()
    local glocale = thorium.glocale

    -- add some translation strings
    glocale.Add("test", "default") -- default, "universal" translation
    glocale.Add("test", "english", "en") -- english translation
    glocale.Add("test", "russian", "ru") -- russian translation
    -- etc...

    -- now verify that it's correct
    assert(glocale.Localize("language is #test") == "language is default", "incorrect translation reported!")
    assert(glocale.Localize("language is #test", "en") == "language is english", "incorrect translation reported!")
    assert(glocale.Localize("language is #test", "ru") == "language is russian", "incorrect translation reported!")
end)