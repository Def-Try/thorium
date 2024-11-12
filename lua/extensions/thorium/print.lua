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

---Similar to print, with the exception of that it automatically formats first string with arguments
---@param text string
---@param ... any
---@return nil
---@diagnostic disable-next-line: lowercase-global
function printf(text, ...)
    return print(string.format(text, ...))
end

---Same as printf, but appends addon name at the start
---@param text string
---@param ... any
---@return nil
function Log(text, ...)
    local info = debug.getinfo(2, "flnS")
    local whois = file.WhereIs(info.short_src, true)
    if whois == "unknown" then
        whois = file.WhereIs(table.concat(string.Split(info.short_src, "/"), "/", 3), true)
    end
    return printf("[%s] "..text, whois, ...)
end

---Same as printf, but appends a bunch of info about caller at the start
function Debug(text, ...)
    local info = debug.getinfo(2, "flnS")
    local whois = file.WhereIs(info.short_src, true)
    if whois == "unknown" then
        whois = file.WhereIs(table.concat(string.Split(info.short_src, "/"), "/", 3), true)
    end
    return printf("[%s: %s() %s:%s] "..text, whois, info.name or "_", info.short_src, info.currentline, ...)
end

---Prints table
---@param tbl table Table to be printed out
---@param indent integer How many tabs to place before each item
---@param done table Tables that already been printed out, to avoid infinite loop
function PrintTable(tbl, indent, done)
    done = done or {}
    indent = indent or 0
    local keys = table.GetKeys(tbl)
    table.sort(keys, function(a, b)
		if isnumber(a) and isnumber(b) then return a < b end
		return tostring(a) < tostring(b)
	end)
    done[tbl] = true
    Msg("{ -- "..tostring(tbl).."\n")
    for i=1, #keys do
        local key = keys[i]
        local val = tbl[key]
        key = (type(key) == "string" and string.format("[%q]", key) or
               string.format("[%s]", tostring(key)))
        val = (type(val) == "table" and (not done[val] and val or "{...}, -- "..tostring(val)) or
               type(val) == "string" and string.format("%q", val) or
               string.format("%s",  tostring(val)))
        Msg(string.rep("\t", indent).."  "..key.."\t=\t")
        if not done[val] and istable(val) then
            ---@cast val table
            PrintTable(val, indent + 2, done)
            Msg(",\n")
            continue
        end
        Msg(val..",\n")
    end
    Msg(string.rep("\t", indent).."}"..(indent == 0 and "\n" or ""))
end