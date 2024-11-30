require("thorium")

local grandom = thorium.grandom

-- create new rng object with seed 1
local random = grandom.New(1)

-- generate and store a bunch of random numbers
local f1, f2, i1, i2 = random:RandFloat(1), random:RandFloat(5, 10),
                        random:RandInt(10), random:RandInt(50, 100)

-- reset our seed
random:SetSeed(0)

-- and verify that our numbers are the same
assert(random:RandFloat(1) == f1,     "random number is invalid!")
assert(random:RandFloat(5, 10) == f2, "random number is invalid!")
assert(random:RandInt(10) == i1,      "random number is invalid!")
assert(random:RandInt(50, 100) == i2, "random number is invalid!")