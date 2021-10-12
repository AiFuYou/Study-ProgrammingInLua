-- 练习6.1：请编写一个函数，该函数的参数为一个数组，打印出该数组的所有元素

function printArr(arr)
	if #arr == 0 then print("空") return end
	print(table.unpack(arr))
end

printArr({1, 2, 3, "a", "b", "c"})

-- 练习6.2：请编写一个函数，该函数的参数为可变数量的一组值，返回值为除第一个元素之外的其他所有值

-- 方法一：
function test6_2_1(...)
	return select(2, ...) 		
end

-- 方法二：
function test6_2_2(first, ...)
	return ...
end

print(test6_2_1("a", "b", "c", "d"))
print(test6_2_2("a", "b", "c", "d"))

-- 练习6.3：请编写一个函数，该函数的参数为可变数量的一组值，返回值为除最后一个元素之外的其他所有值

function test6_3(...)
	local x = table.pack(...)
	table.remove(x)
	return table.unpack(x)
end

print(test6_3(1, 2, 3, 4, 5))

-- 练习6.4：请编写一个函数，该函数用于打乱（shuffle）一个指定的数组请保证所有的排列都是等概率的

-- Fisher–Yates shuffle 洗牌算法
function shuffle(arr)
	math.randomseed(os.time())
	for i=#arr,2,-1 do
		local j = math.random(1, i)
		if i ~= j then
			arr[i], arr[j] = arr[j], arr[i]
		end
	end
	return arr
end

printArr(shuffle({1, 2, 3, 4, 5}))

-- 练习6.5：请编写一个函数，其参数为一个数组，返回值为数组中元素的所有组合。
-- 提示：可以使用组合的递推公式 C(n, m) = C(n-1, m-1) + C(n-1, m)。
-- 要计算从n个元素中选出m个组成的组合C(n, m)，可以先将第一个元素加到结果集中，然后计算所有的其他元素的C(n-1, m-1）；
-- 然后，从结果集中删掉第一个元素，再计算其他所有剩余元素的 C(n-1, m)。
-- 当n小于m时，组合不存在；当m为0时，只有一种组合（一个元素也没有）。

-- 解题思路很简单，每个元素都是有或者没有两种情况，遍历每个元素，共有2 ^ #a个结果

local t = {}
local count = 0
function tes6_5(a, index)
	if index >= #a + 1 then
		printArr(t)
		count = count + 1
	else
		table.insert(t, a[index])
		tes6_5(a, index + 1)
		table.remove(t)
		tes6_5(a, index + 1)
	end
end

tes6_5({1, 2, 3, 4, 5}, 1)
print(count)

-- 练习6.6：有时，具有正确尾调用（proper-tail call）的语句被称为正确的尾递归（properly tail recursive），争论在于这种正确性只与递归调用有关（如果没有递归调用，那么一个程序的最大调用深度是静态固定的）。
-- 请证明上述争论的观点在像Lua语言一样的动态语言中不成立：不使用递归，编写一个能够实现支持无限调用链（unbounded call chain）的程序（提示：参考6.1节）。
-- 没太看懂题目是什么意思






