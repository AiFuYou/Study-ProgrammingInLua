-- 练习5.1：下面代码的输出是什么？为什么？

sunday = "monday";
monday = "sunday";
t = {sunday = "monday", [sunday] = monday}
print(t.sunday, t[sunday], t[t.sunday])
-- 输出依次为monday, sunday, sunday，原因很简单，不再多说

-- 练习5.2：考虑如下代码：
-- a = {};
-- a.a = a
-- a.a.a.a的值是什么？其中的每个a都一样吗？
-- 如果将如下代码追加到上述代码中：
-- a.a.a.a = 3
-- 现在a.a.a.a的值变成什么了？

a = {};
a.a = a
print(a)
print(a.a)
print(a.a.a)
print(a.a.a.a)
-- a.a.a.a的值都是{}，其中的每个a都一样，都指向同一个表的内存地址

a.a.a.a = 3
print(a)
print(a.a)
-- print(a.a.a.a)
-- 如果追加a.a.a.a = 3，则a.a.a.a会报错，追加代码的效果相当于a = {}; a.a = 3，因为a.a是3，变为值，不再是table，无法再继续访问a字段

-- 练习5.3：假设要创建一个以转义序列为值、以转义序列对应字符串为键的表（参见4.1节），请问应该如何编写构造器？

local test = {
    ["bell"] = "\a",
    ["back spack"] = "\b",
    ["from feed"] = "\f",
    -- ...
}

print(test.bell .. test["back spack"] .. test["from feed"])

-- 练习5.4：在Lua语言中，我们可以使用由系数组成的列表{a0, a1, ..., an}来表达多项式an * x ^ n + an-1 * x ^ (n - 1) + ... + a1 * x ^ 1 + a0
-- 请编写一个函数，该函数以多项式（使用表表示）和值x为参数，返回结果为对应多项式的值。

function GetResult(a, x)
    local sum = 0
    for i = 1, #a do
        sum = sum + a[i] * x ^ (i - 1)
    end
    return sum
end

print(GetResult({1, 2, 3}, 2))

-- 练习5.5：改写上述函数，使之最多使用n个加法和n个乘法（且没有指数）
-- 解题关键在于：an * x ^ n + an-1 * x ^ n-1 ... a1 * x ^ 1 + a0 = (((an) * x + an-1) * x + an-2) * x ...
-- 于是可演变成以下公式

local function GetResult2(a, x)
    local sum = 0
    for i = #a, 1, -1 do
        sum = a[i] + sum * x
    end
    return sum
end

print(GetResult2({1, 2, 3}, 2))

-- 练习5.6：请编写一个函数，该函数用于测试制定的表是否为有效的序列。

function IsValidIpairs(a)
    if type(a) ~= "table" then
        return false
    end

    local count = 0
    local size = #a
    for k, v in pairs(a) do
        count = count + 1
    end
    return count == size
end

print(IsValidIpairs({}), IsValidIpairs({1, 2, 3}), IsValidIpairs({a = 1, 1, 2, 3}))

-- 练习5.7：请编写一个函数，该函数将指定列表的所有元素插入到别一个列表的指定位置

function InsertTA2TBByPos(tA, tB, pos)
    if pos > #tB then
        print("目标表被指定的位置不存在")
        return nil
    end

    for i = 1, #tA do
        table.insert(tB, pos, tA[i])
        pos = pos + 1
    end

    return table.unpack(tB)
end

print(InsertTA2TBByPos({"1", "2", "3"}, {"a", "b", "c"}, 1))

-- 练习5.8：表标准库中提供了函数table.concat，该函数将指定表的字符串元素连接在一起：
-- print(table.concat({"hello", " ", "world"})) --> hello world
-- 请实现该函数，并比较在大数据量（具有上百万个元素的表，可利用for循环生成）情况下与标准库之间的性能差异。

function MyTableConcat(a)
    local s = ""
    for i = 1, #a do
        s = s .. a[i]
    end
    return s
end

local tt = {}
for i = 1, 1000000 do
    table.insert(tt, "a")
end

local startTime = os.clock()
print(startTime)--0.041
MyTableConcat(tt)
local MyTableConcatTime = os.clock() - startTime
print(MyTableConcatTime)--76.514
table.concat(tt)
local libTableConcatTime = os.clock() - MyTableConcatTime - startTime
print(libTableConcatTime)--0.013

-- 自己实现的算法时间消耗是标准库的5000多倍
-- Lua的字符串是不可变的，每一次进行连接操作之后，其实就产生了新的字符串，不再是原来的那个了。
-- 于是，不断连接，就不断产生新的字符串，产生新字符串是需要复制操作，随着连接操作的不断进行，字符串越来越大，复制操作也就越来越耗时。
