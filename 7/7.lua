-- 练习7.1：请编写一个程序，该程序读取一个文本文件然后将每行的内容按照字母表顺序排序后重写该文件。
-- 如果调用时不带参数，则从标准输入读取并向标准输出写入；
-- 如果调用时传入一个文件名作为参数，则从该文件中读取并向标准输出写入；
-- 如果调用时传入两个文件名作为参数，则从第一个文件读取并将结果写入第二个文件中。

local function sortByWord(str)
    local t = {string.byte(str, 1, -1)}
    table.sort(t)
    str = string.char(table.unpack(t))
    io.write(str, "\n")
end

function fileExists(fileName)
    local f = io.open(fileName, "r")
    if f then
        io.close(f)
        return true
    end
    return false
end

function sortFileLines(inputFile, outputFile)
    if outputFile then
        -- 练习7.2--start
        local userResult = false
        if fileExists(outputFile) then
            print(string.format("File %s exists, rewrite?(y/n)", outputFile))
            local i = io.read()
            userResult = i == "y" or i == "Y"
        end
        -- 练习7.2--end
        
        if userResult then
            io.output(outputFile)
        end
    end

    if inputFile then
        io.input(inputFile)
    end

    for line in io.lines() do
        sortByWord(line)
    end
end

-- sortFileLines()
-- sortFileLines("test_7_1_input.txt")
-- sortFileLines("test_7_1_input.txt", "test_7_1_output.txt")

-- 练习7.2：改写7.1的程序，使得当指定的输出文件已经存在时，要求用户确认。
-- 见以上解答

-- 练习7.3：对比使用下列几种不同的方式把标准输入流复制到标准输出流中的Lua程序性能表现：
-- 按字节
-- 按行
-- 按块
-- 一次性读取整个文件
-- 对于最后一种情况，输入文件最大支持多少？
-- 取决于解释器能分配的最大内存，不过最好一次性不要操作几十mb以上的文件（参见 www.lua.org/pil/21.2.1.html）

function test_7_3_byte()
    local startTime = os.clock()
    io.input("test_7_3.txt")
    local s = io.read("a")
    local bytes = {string.byte(s, 1, -1)}
    for _, v in ipairs(bytes) do
        io.write(string.char(v))
    end
    return os.clock() - startTime
end

function test_7_3_line()
    local startTime = os.clock()
    for line in io.lines("test_7_3.txt") do
        io.write(line)
    end
    return os.clock() - startTime
end

function test_7_3_chunk()
    local startTime = os.clock()
    local chunkSize = 2 ^ 13
    io.input("test_7_3.txt")
    while true do
        local tmpS = io.read(chunkSize)
        if not tmpS then break end
        io.write(tmpS)
    end
    return os.clock() - startTime
end

function test_7_3_once()
    local startTime = os.clock()
    io.input("test_7_3.txt")
    local onceS = io.read("a")
    io.write(onceS)
    return os.clock() - startTime
end

-- local byteTime = test_7_3_byte()
-- local lineTime = test_7_3_line()
-- local chunkTime = test_7_3_chunk()
-- local onceTime = test_7_3_once()
-- print()
-- print("byte  time:", byteTime)
-- print("line  time:", lineTime)
-- print("chunk time:", chunkTime)
-- print("once  time:", onceTime)

-- 练习7.4：请编写一个程序，该程序输出一个文本文件的最后一行。当文件较大时且可以使用seek时，尝试避免读取整个文件来完成。
-- 练习7.5：请将7.4的程序修改得更加通用，使其可以输出一个文本文件得最后n行。当文件较大时且可以使用seek时，尝试避免读取整个文件来完成。

-- 方法一：读取整个文件
function getLastNLines(n, file)
    local t = {}
    for line in io.lines(file) do
        table.insert(t, line)
    end

    local tn = #t

    local startN = (n > tn and 0 or (tn - n)) + 1
    for i = startN, tn do
        print(t[i])
    end
end

-- getLastNLines(5, "test_7_3.txt")

-- 方法二：使用seek
function fsize(file)
    local cur = file:seek()
    local size = file:seek("end")
    file:seek("set", cur)
    return size
end

function getLastNLines2(n, file)
    local f = io.open(file, "r")
    if not f then
        print("no file")
        return
    end

    n = n > 0 and n or 1
    local fileSize = fsize(f)
    local loopTime = 1
    local buffSize = 1024
    while true do
        local curSize = fileSize - f:seek("end", math.max(-loopTime * buffSize, -fileSize))
        local text = f:read("a")
        local _, count = string.gsub(text, "\n", "\n")
        if count > n - 1 then
            local diff = count - (n - 1)
            while diff > 0 do
                local start = string.find(text, "\n")
                text = string.sub(text, start + 1, -1)
                diff = diff - 1
            end
            print(text)
            break
        else
            if curSize == fileSize then
                print("N large than lines num", curSize, fileSize, loopTime)
                print(text)
                break
            else
                loopTime = loopTime + 1
            end
        end
    end
end

-- getLastNLines2(100000, "test_7_3.txt")

-- 练习7.6：使用函数os.execute和io.popen，分别编写用于创建目录、删除目录和输出目录内容的函数。

-- 使用函数os.execute
function createDir(dir)
    os.execute("mkdir " .. dir)
end

function removeDir(dir)
    os.execute("rmdir /s " .. dir)
end

function lsDir(dir)
    os.execute("dir " .. dir)
end

-- createDir("test_7_6")
-- lsDir("test_7_6")
-- removeDir("test_7_6")

-- 使用函数io.popen
function createDir2(dir)
    local f = io.popen("mkdir " .. dir, "r")
    if f then
        print(f:read("a"))
        f:close()
    end
end

function removeDir2(dir)
    local f = io.popen("rmdir /s " .. dir, "r")
    if f then
        print(f:read("a"))
        f:close()
    end
end

function lsDir2(dir)
    local f = io.popen("dir " .. dir, "r")
    if f then
        print(f:read("a"))
        f:close()
    end
end

-- createDir2("test_7_6")
-- lsDir2("test_7_6")
-- removeDir2("test_7_6")

-- 练习7.7：你能否使用函数os.execute来改变Lua脚本的当前目录？为什么？
-- 能
-- 获取到当前文件的位置，调用系统命令将文件移动到目标位置即可

function changeDir(dstDir)
    os.execute("move " .. arg[0] .. " " .. dstDir)
end

-- changeDir("testChangeDir")


