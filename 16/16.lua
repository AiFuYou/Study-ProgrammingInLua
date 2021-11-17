--练习16.1：通常，在加载代码段时增加一些前缀很有用。（我们在本章前面部分已经见过相应的例子，在那个例子中，我们在待加载的表达式前增加了一个return语句。）
--请编写一个函数loadwithprefix，该函数类似于函数load，不过会将第1个参数（一个字符串）增加到待加载的代码段之前。
--像原始的load函数一样，函数loadwithprefix应该既可以接收字符串形式的代码段，也可以通过函数进行读取。即使待加载的代码段是字符串形式的，
--函数loadwithprefix也不应该进行实际的字符串连接操作。相反，它应该调用函数load并传入一个恰当的读取函数来实现功能，这个读取函数首先返回要增加的代码，然后返回原始的代码段。



--练习16.2：请编写一个函数multiload ，该函数接收一组字符串或函数来生成函数loadwithprefix ，如下例所示：
--f = multiload("local x = 10;",
--               io.lines("temp", "*L"),
--               " print(x)")
--在上例中，函数multiload应该加载一段等价于字符串"local..." 、temp文件的内容和字符串"print(x)"连接在一起后的代码。
--与上一练习中的函数loadwithprefix类似，函数multiload也不应该进行任何实际的字符串连接操作。



--练习16.3：示例16.2 中的函数stringrep使用二进制乘法算法（binary multiplication algorithn）来完成将指定字符串s的n个副本连接在一起的需求：
--示倒16.2 字符串复制
--function stringrep(s, n)
--    local r = ""
--    if n > 0 then
--        while n > 1 do
--            if n % 2 ~= 0 then r = r .. s end
--            s = s .. s
--            n = math.floor(n / 2)
--        end
--        r = r .. s
--    end
--    return r
--end
--对于任意固定的n 我们可以通过将循环展开为一系列的r = r .. s 和s=s .. s 语句来创建一个特殊版本的stringrep。
--例如，在n=5时可以展开为如下的函数：
--function stringrep_5(s)
--    local r = ""
--    r  = r.. s
--    s = s .. s
--    s = s .. s
--    r = r.. s
--    return r
--end
--请编写一个函数， 该函数对于指定的n返回特定版本的函数stringrep_n 。在实现方面， 不能使用闭包，而是应该构造出包含合理指令序列（ r = r .. s 和s = s .. s 的组合）的Lua 代码，
--然后再使用函数load生成最终的函数。请比较通用版本的stringrep函数（或者使用该函数的闭包）与我们自己实现的版本之间的性能差异。



--练习16.4：你能否想到一个使pcall(pcall, f)的第1个返回值为false的f？为什么这样的f会有存在的意义呢？