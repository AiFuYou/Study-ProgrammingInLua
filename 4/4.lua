-- 练习4.1：请问如何在Lua程序中以字符串的方式使用如下的XML片段，请给出至少两种实现方式。
-- <! [CDATA[
-- Hello world
-- ]]>

-- 方式一：
local s1 = [=[
<![CDATA[
    Hello world
]]>]=]
print(s1)

-- 方式式二：
local s2 = "<![CDATA[\n    Hello world\n]]>"
print(s2)

-- 练习4.2：假设你需要以字符串常量的形式定义一组包含歧义的转义字符序列，你会使用哪种方式？请注意考虑诸如可读性、每行最大长度及字符串最大长度等问题。
-- 字符串常量使用""或''进行声明，具体应该使用单引号还是双引号，需要根据实际内容进行选择.
-- 如果文本中以双引号为主，就选择使用单引号声明，否则就使用双引号声明。
-- 如果二者差不多，我认为处于习惯考虑应该使用双引号声明，然后对文本中的双引号进行转义。
-- 如果是多行，则可以使用[[]]

-- 练习4.3：请编写一个函数，使之实现在某个字符串的指定位置插入另一个字符串：
-- > insert("hello world", 1, "start: ") --> start: hello world
-- > insert("hello world", 7, "small ") --> hello small world

function insert(s, pos, tmps)
    return string.sub(s, 1, pos - 1) .. tmps .. string.sub(s, pos, -1)
end

print(insert("hello world", 1, "start: "))
print(insert("hello world", 7, "small "))

-- 练习4.4：使用UTF-8字符串重写下例：
-- > insert("ação", 5, "!") --> ação!

function utf8insert(s, pos, tmps)
    local m = utf8.offset(s, pos)
    return string.sub(s, 1, m - 1) .. tmps .. string.sub(s, m, len)
end

print(utf8insert("ação", 5, "!"))

-- 练习4.5：请编写一个函数，该函数用于移除指定字符串中的一部分，移除的部分使用起始位置和长度指定：
-- > remove("hello world", 7, 4) --> hello d

function remove(s, posStart, posEnd)
    return s:sub(1, posStart - 1) .. s:sub(posStart + posEnd, -1)
end

print(remove("hello world", 7, 4))

-- 练习4.6：请使用UTF-8字符串重写下例：
-- > remove("ação", 2, 2) --> ao

function utf8remove(s, posStart, posEnd)
    return s:sub(1, utf8.offset(s, posStart) - 1) .. s:sub(utf8.offset(s, posStart + posEnd), -1)
end

print(utf8remove("ação", 2, 2))

-- 练习4.7：请编写一个函数判断指定的字符串是否为回文字符串（palindrome）：
-- > ispali("step on no pets") --> true
-- > ispali("banana") --> false

function ispali(s)
    return string.reverse(s) == s 
end

print(ispali("step on no pets"))
print(ispali("banana"))

-- 练习4.8：重写之前的练习，使得它们忽略空格和标点符号。

-- 方法一：替换标点符号为空字符串，效率低，每个字符串都要替换一遍
function ispaliexceptxxx1(s)
    s = s:gsub("%.", "")
    s = s:gsub(",", "")
    s = s:gsub(":", "")
    s = s:gsub("'", "")
    s = s:gsub('"', "")
    s = s:gsub("!", "")
    s = s:gsub("?", "")
    s = s:gsub("%]", "")
    s = s:gsub("%[", "")
    s = s:gsub(" ", "")
    -- ... 此处省略要替换的标点符号
    return string.reverse(s) == s
end
print(ispaliexceptxxx1("123.,:'\"!?[ ]321"))

-- 方法二：使用模式匹配去除字符串
function ispaliexceptxxx2(s)
    s = s:gsub("[%p%s]", "")
    return string.reverse(s) == s 
end
print(ispaliexceptxxx2("123.,:'\"!?[ ]321"))

-- 练习4.9：使用UTF-8字符串重写之前的练习

function usf8ispali(s)
    local oT = {}
    for i,v in utf8.codes(s) do
        table.insert(oT, v)
    end

    local nT = {}
    local len = #oT
    for i=1,len do
        nT[len - i + 1] = oT[i]
    end

    return utf8.char(table.unpack(nT)) == s
end

print("açãooãça", usf8ispali("açãooãça"))
print("açãooãça1", usf8ispali("açãooãça1"))
print("我爱国，国爱我", usf8ispali("我爱国，国爱我"))
print("我爱中国，中国爱我", usf8ispali("我爱中国，中国爱我"))
