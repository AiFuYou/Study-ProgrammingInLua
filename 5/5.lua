-- 练习5.1：下面代码的输出是什么？为什么？

sunday = "monday";
monday = "sunday";
t = {sunday = "monday", [sunday] = monday}
print(t.sunday, t[sunday], t[t.sunday])
-- 输出依次为monday	sunday	sunday，原因很简单，不再多说

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
	for i=1,#a do
		sum = sum + a[i] * x ^ (i - 1)
	end
	return sum
end

print(GetResult({1, 2}, 2))

-- 练习5.5：改写上述函数，使之最多使用n个加法和n个乘法（且没有指数）



