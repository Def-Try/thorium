-- we assume that our file runs *before* thorium initialiser.
-- this is usually done by having your file being *higher* than "thorium_init.lua" in sorted names table

assert(thorium == nil) -- at this time thorium should not exist

hook.Add("ThoriumReady", "MyAddon_ThoriumReady", function()
    assert(thorium ~= nil) -- and we should get it only there
end)