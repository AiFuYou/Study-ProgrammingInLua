--源程序
function oriFun(n)
	local counter = {}
	for line in io.lines("test_11_1.txt") do
		for word in string.gmatch(line, "%w+") do
			counter[word] = (counter[word] or 0) + 1
		end
	end

	local words = {}
	for k in pairs(counter) do
		words[#words + 1] = k
	end

	table.sort(words, function (w1, w2)
		return counter[w1] > counter[w2] or counter[w1] == counter[w2] and w1 < w2
	end)

	for i=1,n do
		print(words[i], counter[words[i]])
	end
end

oriFun(10)

--练习11.1：当我们对一段文本执行统计单词出现频率的程序时，结果常常是一些诸如冠词和介词之类的没有太多意义的短词汇。
--请改写该程序，使它忽略长度小于4个字母的单词。

--从输出入手
function funWithIgnoreLen1(n, ignoreLen)
	local counter = {}
	for line in io.lines("test_11_1.txt") do
		for word in string.gmatch(line, "%w+") do
			counter[word] = (counter[word] or 0) + 1
		end
	end

	local words = {}
	for k in pairs(counter) do
		words[#words + 1] = k
	end

	table.sort(words, function (w1, w2)
		return counter[w1] > counter[w2] or counter[w1] == counter[w2] and w1 < w2
	end)

	local curCount = 0
	for _,word in ipairs(words) do
		if (#word >= ignoreLen) then
			print(word, counter[word])--在输出之前检查该单词长度是否符合需求
			curCount = curCount + 1
		end

		if curCount >= n then
			break
		end
	end
end

funWithIgnoreLen1(10, 4)

--从匹配入手
function funWithIgnoreLen2(n, ignoreLen)
	local counter = {}
	local pattern = "%w+"
	for i=1,ignoreLen - 1 do
		pattern = "%w" .. pattern
	end
	for line in io.lines("test_11_1.txt") do
		for word in string.gmatch(line, pattern) do--匹配模式修改为4个或4个字母以上的单词
			counter[word] = (counter[word] or 0) + 1
		end
	end

	local words = {}
	for k in pairs(counter) do
		words[#words + 1] = k
	end

	table.sort(words, function (w1, w2)
		return counter[w1] > counter[w2] or counter[w1] == counter[w2] and w1 < w2
	end)

	for i=1,n do
		print(words[i], counter[words[i]])
	end
end

funWithIgnoreLen2(10, 4)

--练习11.2：重复上面的练习，除了按照长度标准忽略单词外，该程序还能从一个文本文件中读取要忽略的单词列表。

function funWithIgnoreLen3(n, ignoreLen)
	--记录要忽略的单词
	local ignoreWords = {}
	for line in io.lines("ignore_words.txt") do
		for word in string.gmatch(line, "%w+") do
			ignoreWords[word] = true
		end
	end

	local counter = {}
	local pattern = "%w+"
	for i=1,ignoreLen - 1 do
		pattern = "%w" .. pattern
	end
	for line in io.lines("test_11_1.txt") do
		for word in string.gmatch(line, pattern) do
			if not ignoreWords[word] then --在记录单词数量时进行忽略
				counter[word] = (counter[word] or 0) + 1
			end
		end
	end

	local words = {}
	for k in pairs(counter) do
		words[#words + 1] = k
	end

	table.sort(words, function (w1, w2)
		return counter[w1] > counter[w2] or counter[w1] == counter[w2] and w1 < w2
	end)

	for i=1,n do
		print(words[i], counter[words[i]]) --也可以在进行输出时检查忽略
	end
end

funWithIgnoreLen3(10, 0)




