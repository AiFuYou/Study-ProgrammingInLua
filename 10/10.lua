--练习10.1：请编写一个函数split，该函数接收两个参数，第1个参数是字符串，第2个参数是分隔符模式，
--函数的返回值是分隔符分割后的原始字符串中的每一部分的序列：
--t = split("a whole new world", " ")
--t = {"a", "whole", "new", "world")
--你编写的函数是如何处理空字符串的呢？特别是，一个空字符串究竟是空序列(an empty sequence)，
--还是一个具有字符串的序列呢（a sequence with one empty string）？

--当输入的字符串为空时，返回一个空表（也可以返回nil，根据需求定）
--当输入的分割符为空时，返回只有一个元素的表

function split(s, sp)
    local t = {}

    if s == nil or s == "" then
        return t
    end

    if sp == nil or sp == "" then
        t[1] = s
        return t
    end

    local startPos, endPos, maxLength = 1, 1, #s
    while endPos ~= nil do
        endPos = string.find(s, sp, startPos)
        if endPos then
            table.insert(t, string.sub(s, startPos, endPos - 1))
            startPos = endPos + 1
        end
    end

    if startPos <= maxLength then
        table.insert(t, string.sub(s, startPos, maxLength))
    end
    
    return t
end

function split2(s, sp)
    local t = {}

    if s == nil or s == "" then
        return t
    end

    if sp == nil or sp == "" then
        t[1] = s
        return t
    end
    
    for v in string.gmatch(s, "[^" .. sp .. "]+") do--匹配除sp以外的所有字符
        table.insert(t, v)
    end
    return t
end

local tmpT = split("a whole new world", " ")
for i = 1, #tmpT do
    io.write(tmpT[i], ",")
end

io.write("\n")
tmpT = split2("a whole new world", " ")
for i = 1, #tmpT do
    io.write(tmpT[i], ",")
end
io.write("\n")

--练习10.2：模式'%D'和'[^%d]'是等价的，那么模式'[^%d%u]'和'[%D%U]'呢？

--% D，非数字
--[^%d]，非数字

--% U，非大写字母
--[^%u]，非大写字母

--[^%d%u]，非数字且非大写字母
--[%D%U]，非数字或者非大写字母

print(string.match("A1", "[^%d%u]"))--nil
print(string.match("A1", "[^%d%u]"))--nil
print(string.match("A1", "[%D%U]"))--A
print(string.match("1", "[%D%U]"))--1

--由以上分析实践可得，模式'[^%d%u]'和'[%D%U]'不等价

--练习10.3：请编写一个函数transliterate，该函数接受两个参数，第1个参数是字符串，第二个参数是一个表。
--函数transliterate根据第2个参数中的表使用一个字符替换字符串中的字符。如果表中将a映射为b，那么该函数将所有a替换为b。
--如果表中将a映射为false，那么该函数则把结果中的所有a移除。

function transliterate(s, t)
    if not s or s == "" then
        return ""
    end

    if not t then
        return s
    end
    
    for a, b in pairs(t) do
        if b then
            s = string.gsub(s, a, b)
        else
            s = string.gsub(s, a, "")
        end
    end
    return s
end

function transliterate2(s, t)
    if not s or s == "" then
        return ""
    end

    if not t then
        return s
    end
    
    s = string.gsub(s, ".", function(a)
        local v = t[a]
        if v == false then
            return ""
        elseif v ~= nil then
            return v
        else
            return a
        end
    end)
    
    return s
end

local tmpS1 = "Hello World, Hello Lua, Hello Code!"
local tmpT1 = {[","] = ".", ["!"] = false, ["Hello"] = "ByeBye"}--若需要替换字符串，则使用方法一（有缺陷，如果a映射成b，了又映射成c，则a最终会变成c）
print(transliterate(tmpS1, tmpT1))

local tmpT2 = {[","] = ".", ["!"] = false, ["H"] = "HH"}--如果仅仅替换字符，则使用方法二
print(transliterate2(tmpS1, tmpT2))

--练习10.4：在10.3节的最后，我们定义了一个trim函数。由于该函数使用了回溯，所以对于某些字符串来说该函数的时间复杂度是O(n^2)。
--例如：在笔者的新机器上，针对一个100KB大小字符串的匹配可能会耗费52秒。
--●构造一个可能会导致函数trim耗费O(n^2)时间复杂度的字符串。
--●重写这个函数使得其时间复杂度为O(n)。

function trim(s) --每个字符间都有空格的情况下复杂度为O(n^2) 
    s = string.gsub(s, "^%s*(.-)%s*$", "%1")
    return s
end

function trim2(s) --O(n)
    local n = string.find(s, "%S")
    if n then
        return string.match(s, ".*%S", n)
    end
    return ""
end

function trim3(s)
    return s:match'^%s*(.*%S)' or ''
end

local ts1 = "  a  b c  "
local rt1 = trim(ts1)
local rt2 = trim2(ts1)
local rt3 = trim3(ts1)
print(string.gsub(rt1, " ", ","))
print(string.gsub(rt2, " ", ","))
print(string.gsub(rt3, " ", ","))
--更多示例请参考：http://lua-users.org/wiki/StringTrim

--练习10.5：请使用转义序列\x编写一个函数，将一个二进制字符串格式转化为Lua语言中的字符串常量：
--print(escape("\0\1hello\200"))
--> \x00\x01\x68\x65\x6C\x6C\x6F\xC8
--作为优化，请同时使用转义序列\z打破较长的行。

function escape(s)
    local n = 0
    s = string.gsub(s, ".", function(c)
        n = n + 1
        if n >= 10 then
            n = 0
            return string.format("\\x%02X\\z\n", string.byte(c))
        else
            return string.format("\\x%02X", string.byte(c)) 
        end
    end)
    return s
end

print(escape("\0\1hello\200"))
--第二个问题的问法比较奇怪，刚开始没有理解，其实就是如果输出的字符串特别长，那么换行输出，并使用\z标记换行
print(escape("0123456789012345678901234567890123456789"))

--练习10.6：请为UTF-8字符重写函数transliterate。

local st = "abc我爱中国，中国爱我123"
local tt = {
    ["我"] = "你",
    ["abc"] = false,
    ["123"] = false
}
print(transliterate(st, tt))--10.3的习题中，第一个解可以完美替换

function transliterate_utf8(s, t)
    if not s or s == "" then
        return ""
    end

    if not t then
        return s
    end

    s = string.gsub(s, ".[\128-\191]*", function(a)
        local v = t[a]
        if v == false then
            return ""
        elseif v ~= nil then
            return v
        else
            return a
        end
    end)

    return s
end

print(transliterate_utf8(st, tt))--只可替换utf8字符

--练习10.7请编写一个函数，该函数用于逆转一个UTF-8字符串。

function utf8Reverse(s)
    local oT = {}
    for _, v in utf8.codes(s) do
        table.insert(oT, v)
    end

    local nT = {}
    local len = #oT
    for i = 1, len do
        nT[len - i + 1] = oT[i]
    end

    return utf8.char(table.unpack(nT))
end

local x = "我爱你"
print(x, utf8Reverse(x))
--参考4.9
