-- 练习1.1：运行阶乘函数的示例并观察，如果输入负数，程序会出现什么问题？试着修改代码来解决问题。
-- 如果输入负数，程序会无限递归，直到溢出
-- 解决
function fact(n)
    if n < 0 then
        print(string.format("输入%s非法！请输入大于等于0的数字", n))
        return nil
    end
    if n == 0 then
        return 1
    else
        return n * fact(n - 1)
    end
end

print(fact(3))
print(fact(-3))



-- 练习1.2：分别使用 -i 参数和 dofile 加载脚本并运行 twice 示例，你更喜欢哪种方式？ (注意是 -i 不是 -l 中文版印刷有错误)

-- 使用 -i 参数
-- lua -i 1.lua
-- > twice(2)
-- 4.0

-- 使用 dofile
-- lua
-- > dofile("1.lua")
-- > twice(2)
-- 4.0

-- 谈不上更喜欢哪个，不过在编写代码时多数使用require或dofile，-i 参数几乎没有使用过

function twice(x)
    return 2.0 * x
end



-- 练习1.3：你能否列举出其他使用 "--" 作为注释的语言
-- 通过查询得知：Euphoria, Haskell, SQL, Ada, AppleScript, Eiffel, Lua, VHDL, SGML, PureScript
-- 查询地址：https://en.wikipedia.org/wiki/Comparison_of_programming_languages_(syntax)#Comments



-- 练习1.4：以下字符串中哪些是有效的标识符
-- ___ _end End end until? nil NULL one-step
-- local ___ = 1 --有效
-- local _end = 1 --有效
-- local End = 1 --有效
-- local end = 1 --关键字
-- local until? = 1 --问号非法
-- local nil = 1 --关键字
-- local NULL = 1 --有效
-- local one-step = 1 --减号非法
-- 标识符定义：Lua语言中的标识符（或名称）是由任意字母、数字和下划线组成的字符串（注意，不能以数字开头）



-- 练习1.5：表达式 type(nil) == nil 的值是什么？（你可以运行代码来检查下答案）你能解释下原因吗？
print(type(nil) == nil) --false
print(type(type(nil))) --string
-- type(nil)的返回值类型为string



-- 练习1.6：除了使用函数 type 外，如何检查一个值是否为 Boolean 类型？

function checkIsBoolean(b)
    return b == true or b == false
end

print(checkIsBoolean(1)) --false
print(checkIsBoolean("1")) --false
print(checkIsBoolean({})) --false
print(checkIsBoolean(true)) --true
print(checkIsBoolean(false)) --true
print(checkIsBoolean(nil)) --false



-- 练习1.7：考虑如下的表达式：
-- (x and y and (not z)) or ((not y) and z)
-- 其中的括号是否是必须的？你是否推荐在这个表达式中使用括号？
-- 括号不是必须的，优先级 not > and > or，去掉括号后完全一样
-- 推荐使用括号，代码易读性高



-- 练习1.8：请编写一个可以打印出脚本自身名称的程序（事先不知道脚本自身的名称）。
if arg and arg[0] then
    local path = arg[0]
    print(path)
end
