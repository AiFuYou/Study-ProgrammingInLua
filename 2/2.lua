-- 八皇后
-- nxn的棋盘放置n个棋子，横向，纵向，对角不能同时存在两个
-- 算法的实现比较简单，放置第n个棋子时检查第n个棋子的位置与前n-1个已经放好的棋子的位置是否在同一行，列或对角线上
-- 代码如下：

local N = 8
local count = 0
local isPlaceOkCount = 0

local function isPlaceOk(t, hang, lie)
    isPlaceOkCount = isPlaceOkCount + 1
    for i = 1, hang - 1 do --检查与前hang-1个棋子的位置关系
        if t[i] == lie --同一列
            or t[i] - i == lie - hang --同一对角线（从左上到右下对角线上的行列值相减结果相等，如(2, 1), (3, 2), (4, 3))
            or t[i] + i == lie + hang then --同一对角线(从右上到左下对角线上的行列值相加结果相等，如(1, 8), (2, 7), (3, 6))
            return false
        end
    end
    return true
end

-- 打印结果
local function printResult(t)
    for i = 1, N do
        for j = 1, N do
            io.write(t[i] == j and "X" or "-", " ")
        end
        io.write("\n")
    end
    io.write("\n")
end

-- 主逻辑
local function addQueue(t, hang)
    if hang > N then
        printResult(t)
        count = count + 1
    else
        for lie = 1, N do
            if isPlaceOk(t, hang, lie) then
                t[hang] = lie

                -- if count > 0 then return end --练习2.1解答
                addQueue(t, hang + 1)
            end
        end
    end
end

addQueue({}, 1)
print(count)
print(string.format("方法1调用isPlaceOk次数：%s", isPlaceOkCount))

-- 练习2.1：修改八皇后问题的程序，使其在输出第一个解后即停止运行。
-- 如上练习2.1解答，打开注释的代码即可

-- 练习2.2：解决八皇后问题的另一种方式是，先生成 1-8 之间的所有排列，然后依次遍历这些排列，检查每一个排列是否是八皇后问题的有效解。
-- 请使用这种方法修改程序，并对比新程序与旧程序之间的性能差异（提示，比较调用 isplaceok 函数的次数）

isPlaceOkCount = 0
count = 0

local function addQueue2(t, n)
    if n > N then
        local ok = true
        for i = 2, N do
            if not isPlaceOk(t, i, t[i]) then
                ok = false
                break
            end
        end

        if ok then
            count = count + 1
        end
    else
        for i = 1, N do
            t[n] = i
            addQueue2(t, n + 1)
        end
    end
end

addQueue2({}, 1)
print(count)
print(string.format("方法2调用isPlaceOk次数：%s", isPlaceOkCount))

-- 方法1调用isPlaceOk次数：15720
-- 方法2调用isPlaceOk次数：34112320
-- 经对比，方法一效率更高
