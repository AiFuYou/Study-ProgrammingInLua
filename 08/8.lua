--练习8.1：大多数C语法风格的编程语言都不支持elseif结构，为什么Lua语言比这些语言更需要这种结构？
--由于Lua语言不支持switch语句，所以这种一连串的else-if语句比较常见。

--练习8.2：描述Lua语言中实现无条件循环的4种不同方法，你更喜欢哪一种？
--while-do
--repeat-until（相当于do-while，但是Lua不支持do-whild）
--for
--goto
--前3个很常用，不再多说，下面介绍下第四个怎么实现无条件循环
--local count = 1
--::loop::
--count = count + 1
--print(count)
--goto loop

--练习8.3：很多人认为，由于repeat-until很少使用，因此像Lua语言这样的简单的编程语言中最好不要出现，你怎么看？
--我个人认为有用，repeat-until就跟do-while一样。至少执行一次，与while-do至少执行0次的逻辑还是有区别的。

--练习8.4：正如在6.4节中我们所见到的，尾部调用伪装成了goto语句。请用这种方法重写8.2.5节的迷宫游戏。每个房间此时应该是一个新函数，而每个goto语句都变成了一个尾部调用。

function room1()
    local move = io.read()
    if move == "south" then
        return room3()
    elseif move == "east" then
        return room2()
    else
        print("invalid move")
        return room1()
    end
end

function room2()
    local move = io.read()
    if move == "south" then
        return room4()
    elseif move == "west" then
        return room1()
    else
        print("invalid move")
        return room2()
    end
end

function room3()
    local move = io.read()
    if move == "north" then
        return room1()
    elseif move == "east" then
        return room4()
    else
        print("invalid move")
        return room3()
    end
end

function room4()
    print("Congratulations, you won!")
end

--room1()

--练习8.5：请解释一下为什么Lua语言会限制goto语句不能跳出一个函数。（提示：你要如何实现这个功能？）
--如果不加以限制，则goto会导致代码结构变的混乱，不易阅读理解
--因为在进入一个函数的时候，编译器需要保存现场，将上下文进行压栈，如果goto语句可以跳出一个函数的话，必须要保存现场以便返回，但是这样就没有使用goto的必要了。
--goto语句及其目标必须位于同一堆栈帧中. goto之前和之后的程序上下文需要相同，否则跳转到的代码将不会在其正确的堆栈帧中运行，并且其行为将是未定义的。

--练习8.6：假设goto语句可以跳转出函数，请说明示例8.3中的程序将会如何执行。
--示例8.3：
--function getlabel()
--    return function() goto L1 end
--    ::L1::
--    return 0
--end
--
--function f(n)
--    if n == 0 then return getlabel()
--    else
--        local res = f(n - 1)
--        print(n)
--        return res
--    end
--end
--
--x = f(10)
--x()
--试着解释为什么标签要使用与局部变量相同的作用范围规则。

--如果可以跳出函数，则f(10)=f(9)=f(8)=f(7)=f(6)=f(5)=f(4)=f(3)=f(2)=f(1)=f(0)=0
--以下答案参考自：https://www.jianshu.com/p/ed30bea56b35
--当n=0的时候getlabel已经return了，当goto以后就不知道会跳转到哪里去了。
--如果直接使用栈中的上下文数据，会直接从f(1)返回到f(2)但值不能保证传给了f(2)的res。
--从编译原理的角度说，return值是通过公共的内存区域来共享的，但f(0)并不知道f(2)的公共区域地址在哪里，所以会导致很多奇怪的错误。
--正因为有程序栈的存在，所以不能随意的在不同的块中随意跳转。

