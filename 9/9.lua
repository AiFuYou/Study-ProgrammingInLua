--练习9.1：请一个函数integral，该函数以一个函数f为参数并返回其积分的近似值。
--什么是积分近似值？就是曲线与轴之前面积。参考链接：https://www.shuxuele.com/calculus/integral-approximations.html

local integral = function(f, x1, x2, delta) 
    delta = delta or 1e-4
    
    local result = 0
    for i = x1, x2, delta do
        result = result + f(i) * delta
    end
    return result
end

local test = function(x)
    return -x + 1
end

print(integral(test, 0, 1))

--练习9.2：请问如下的代码段将输出怎样的结果？
function F(x)
    return{
        set = function(y) x = y end,
        get = function() return x end
    }
end

o1 = F(10)
o2 = F(20)
print(o1.get(), o2.get())

o2.set(100)
o1.set(300)
print(o1.get(), o2.get())

--输出结果如下：
--10      20
--300     100

--练习9.3：练习5.4要求我们编写一个以多项式（使用表表示）和值x为参数、返回结果为对应多项式值的函数。请编写该函数的柯里化（curried）版本，
--该版本的函数应该以一个多项式为参数并返回另一个函数（当这个函数的入参是值x时返回对应多项式的值）。考虑如下的示例：

function newpoly(a)
    return function (x)
        local sum = 0
        for i = 1, #a do
            sum = sum + a[i] * x ^ (i - 1)
        end
        return sum
    end
end

f = newpoly({3, 0, 1})
print(f(0))     --3
print(f(5))     --28
print(f(10))    --103

--什么是柯里化（curried）？
--是指通过一个函数对多个参数求值的过程变换为对一个只接收一个参数的函数序列求值的技巧。
--参考链接：https://en.wikipedia.org/wiki/Currying

--练习9.4：使用几何区域系统的例子，绘制一个北半球（northern hemisphere）所能看到的蛾眉月（waxing crescent moon）。

function plot(r, M, N)
    io.write("P1\n", M, " ", N, "\n")   --文件头
    for i = 1, N do
        local y = (N - i * 2) / N
        for j = 1, M do
            local x = (j * 2 - M) / M
            io.write(r(x, y) and "1" or "0")
        end
        io.write("\n")
    end
end

function disk(cx, cy, r)
    return function(x, y) 
        return (x - cx) ^ 2 + (y - cy) ^ 2 <= r ^ 2
    end
end

function difference(r1, r2)
    return function(x, y)
        return r1(x, y) and not r2(x, y)
    end
end

function translate(r, dx, dy)
    return function(x, y)
        return r(x - dx, y - dy)
    end
end

c1 = disk(0, 0, 1)
plot(difference(c1, translate(c1, 0.3, 0)), 50, 50)   --南半球
plot(difference(c1, translate(c1, -0.3, 0)), 50, 50)    --北半球

--练习9.5：在几何区域系统的例子中，增加一个函数来实现将指定的区域旋转指定的角度。

function rect(left, right, bottom, up)
    return function(x, y)
        return left <= x and x <= right and bottom <= y and y <= up
    end
end

function rotation(r, angle)
    return function(x, y)
        local rad = math.rad(angle)
        return r(x * math.cos(rad) - y * math.sin(rad), x * math.sin(rad) + y * math.cos(rad))  --坐标旋转工式，可google查询
    end
end

local c2 = rect(-1, 1, -1, 1)
plot(difference(c2, rotation(c2, 45)), 50, 50)
