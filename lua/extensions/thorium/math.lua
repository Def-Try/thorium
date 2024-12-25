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

---Performs Bezier Interpolation
---@param p0 number
---@param p1 number
---@param p2 number
---@param t number
---@return number
function math.Bezier(p0, p1, p2, t)
    local l00 = Lerp(t, p0, p1)
    local l01 = Lerp(t, p1, p2)
    return Lerp(t, l00, l01)
end

---Performs Bezier Interpolation on Vectors
---@param p0 Vector
---@param p1 Vector
---@param p2 Vector
---@param t number
---@return Vector
function math.BezierVector(p0, p1, p2, t)
    local l00 = LerpVector(t, p0, p1)
    local l01 = LerpVector(t, p1, p2)
    return LerpVector(t, l00, l01)
end

---Performs Bezier Interpolation on Angles
---@param p0 Angle
---@param p1 Angle
---@param p2 Angle
---@param t number
---@return Angle
function math.BezierAngle(p0, p1, p2, t)
    local l00 = LerpAngle(t, p0, p1)
    local l01 = LerpAngle(t, p1, p2)
    return LerpAngle(t, l00, l01)
end