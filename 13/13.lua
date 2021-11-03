--练习13.1：请编写一个函数，该函数用于进行无符号整型数的取模运算。



--练习13.2：请实现计算Lua语言中整形数所占用位数的不同方法。

function isInteger(n)
    return math.type(n) == "integer"
end

function countBit(n)
    if isInteger(n) then
        n = math.abs(n)
        local count = 0
        while n ~= 0 do
            n = n >> 1
            count = count + 1
        end
        return count
    else
        return "input number is not integer" 
    end
    
end

print(countBit(1), countBit(2), countBit(4), countBit(-4), countBit(1.1))

--练习13.3：如何判断一个指定的整数是不是2的整数次幂?

function is2ZhengCiMi(n)
    if isInteger(n) then
        return n > 0 and n & (n - 1) == 0--2的整次幂有特点，减1后与原值做与运算结果为0
    else
        return "input number is not integer"
    end
end

print(is2ZhengCiMi(1), is2ZhengCiMi(0), is2ZhengCiMi(3), is2ZhengCiMi(4), is2ZhengCiMi(-4))

--练习13.4：请编写一个函数，该函数用于计算指定整数的汉明权重（一个数的汉明权重（Hamming weight）是其二进制表示中的1的个数）

function getHammingWeight(n)
    if isInteger(n) then
        n = math.abs(n)
        
        local count = 0
        while n ~= 0 do
            if n & 1 == 1 then
                count = count + 1
            end
            
            n = n >> 1
        end
        
        return count
    else
        return "input number is not integer"
    end
end

for i = 1, 10 do
    print("getHammingWeight", i, getHammingWeight(i))
end

--练习13.5：请编写一个函数，该函数用于判断指定整数的二进制表示是否为回文数。

function isPalindromeInteger(n)
    if isInteger(n) then
        n = math.abs(n)
        
        local t = {}
        while n ~= 0 do
            table.insert(t, n & 1 == 1 and 1 or 0)
            n = n >> 1
        end
        
        local s = table.concat(t, "")

        local count = #t
        local mid = count // 2
        for i = 1, mid do
            if t[i] ~= t[n - i + 1] then
                return s, false, string.reverse(s) == s
            end 
        end
        return s, true, string.reverse(s) == s
    else
        return "input number is not integer"
    end
end

for i = 1, 10 do
    print("isPalindromeInteger", i, isPalindromeInteger(i))
end

--练习13.6：请在Lua语言中实现一个比特数组（bit array），该数组应支持如下操作。
--● newBitArray(n) (创建一个有n个bit的数组)。
--● setBit(a, n, v) (将boolean值v赋值给数组a的第n位)。
--● testBit(a, n) (将第n位的值作为布尔值返回)。

function newBitArray(n)
    local a = {}
    for i = 1, n do
        a[i] = false
    end
    return a
end

function setBit(a, n, v)
    if a and n <= #a then
        a[n] = v
    end
end

function testBit(a, n)
    return a and a[n] or false
end

local ta = newBitArray(10)
setBit(ta, 1, true)

for i = 1, #ta do
    print("xxx", i, testBit(ta, i))
end

print("xxx", 11, testBit(ta, 11))

--练习13.7：假设有一个以一系列记录组成的二进制文件，其中的每一个记录的格式为：
--struct Record{
--    int x;
--    char[3] code;
--    float value;
--};
--请编写一个程序，该程序读取这个文件，然后输出value字段的总和。

--这个题考察的其实是打包和解包二进制数据，注意打包和解包使用的fmt和单个包的总字节数
--int值占3个字节
--字符串占4个字节
--float默认占8个字节
local fmt = "i3s4f"
local blockSize = 15

function generateFile()
    local s = string.pack(fmt, 1000, "1234", 1.1)
    s = s .. string.pack(fmt, 2, "2341", 1.2)
    s = s .. string.pack(fmt, 3, "3412", 1.3)
    s = s .. string.pack(fmt, 4, "4123", 1.4)

    print(s)
    io.output("13.txt")
    io.write(s)
    io.close()
end

function parseTest()
    local sum = 0
    local f = assert(io.open("13.txt", "rb"))
    
    for bytes in f:lines(blockSize) do
        print(bytes)
        _1, _2, t = string.unpack(fmt, bytes)
        print(_1, _2, t)
        sum = sum + t
    end
    return sum
end

generateFile()
print(parseTest())
