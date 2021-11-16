-- 源函数
function serialize(o)
	local t = type(o)
	if t == "number" or t == "string" or t == "boolean" or t == "nil" then
		io.write(string.format("%q", o))
	elseif t == "table" then
		io.write("{\n")
		for k,v in pairs(o) do
			io.write("    ", string.format("[%q]", k), " = ")
			serialize(v)
			io.write(",\n")
		end

		io.write("\n}")
	else
		error("cannot serialize a " .. t)
	end
end

local tt = {
	a = 12, 
	b = "lua", 
	key = 'another "one"', 
	c = {1, 2, 3}, 
	d = {haha = 1, hehe = b, "ccc"}, 
	"aaa", 
	"bbb"
}
-- serialize(tt)

--练习15.1：修改15.2中的代码，使其带缩进地输出嵌套表（提示：给函数serialize增加一个额外的参数来处理缩进字符串）。
--如下解答，给serialize函数增加了n来处理缩进字符串，如果key为number类型，则必须要添加[]

function n2space(n)
	return string.rep(" ", n * 4)
end

function serialize_151(o, n)
	n = n or 0
	local space = n2space(n)

	local t = type(o)
	if t == "number" or t == "string" or t == "boolean" or t == "nil" then
		io.write(string.format("%q", o))
	elseif t == "table" then
		n = n + 1
		io.write("{\n")
		for k,v in pairs(o) do
			if type(k) == "number" then
				io.write(space, "    ", string.format("[%q]", k), " = ")--题目15.3解答
			else
				io.write(space, "    ", k, " = ")
			end
			
			serialize_151(v, n)
			io.write(",\n")
		end
		io.write(space, "}")
	else
		error("cannot serialize a " .. t)
	end
end

-- serialize_151(tt)

--练习15.2：修改前面练习中的代码，使其像15.2.1节中的推荐的那样使用形如["key"] = value的语法。

function serialize_152(o, n)
	n = n or 0
	local space = n2space(n)

	local t = type(o)
	if t == "number" or t == "string" or t == "boolean" or t == "nil" then
		io.write(string.format("%q", o))
	elseif t == "table" then
		n = n + 1
		io.write("{\n")
		for k,v in pairs(o) do
			io.write(space, "    ", string.format("[%q]", k), " = ")--只需修改这里即可
			serialize_152(v, n)
			io.write(",\n")
		end
		io.write(space, "}")
	else
		error("cannot serialize a " .. t)
	end
end

-- serialize_152(tt)

--练习15.3：修改前面练习中的代码，使其只在必要时（即当键为字符串而不是合法标识符时）才使用形如["key"] = value的语法。
--15.1中已做过解答

--练习15.4：修改前面练习中的代码，使其在可能时使用列表的构造器语法。例如，应将表{14, 15, 19}序列化为{14, 15, 19}而不是
--{[1] = 14, [2] = 15, [3] = 19}（提示：只要键不是nil就从1,2,...开始保存对应键的值。请注意，在遍历其余表的时候不要再次保存它们）。
--没太理解题目的意思，可能只是把所有key去掉，然后以列表的方式只保存值

function serialize_153(o, n)
	n = n or 0
	local space = n2space(n)

	local t = type(o)
	if t == "number" or t == "string" or t == "boolean" or t == "nil" then
		io.write(string.format("%q", o))
	elseif t == "table" then
		n = n + 1
		io.write("{\n")
		for k,v in pairs(o) do
			io.write(space, "    ")
			serialize_153(v, n)
			io.write(",\n")
		end
		io.write(space, "}")
	else
		error("cannot serialize a " .. t)
	end
end

-- serialize_153(tt)

--练习15.5：在保存具有循环的表时，避免使用构造器的方法过于激进了。对于简单的情况，是能够使用表构造器以一种更加优雅的方式来保存表的，
--并且也能够在后续使用赋值语句来修复共享表和循环。请使用这种方式重新实现函数save（示例15.3），其中要运用前面练习中的所有优点（缩进、记录式语法及列表式语法）。
--题目意思没有完全明白

tt.tt = tt

function serialize_154(o, n, saved)
	n = n or 0
	saved = saved or {}

	local space = n2space(n)

	local t = type(o)
	if t == "number" or t == "string" or t == "boolean" or t == "nil" then
		io.write(string.format("%q", o))
	elseif t == "table" then
		if saved[o] then
			io.write(saved[o], "\n")
		else
			saved[o] = t

			n = n + 1
			io.write("{\n")
			for k,v in pairs(o) do
				io.write(space, "    ", string.format("[%q]", k), " = ")--只需修改这里即可
				serialize_154(v, n, saved)
				io.write(",\n")
			end
			io.write(space, "}")
		end
	else
		error("cannot serialize a " .. t)
	end
end

serialize_154(tt)


