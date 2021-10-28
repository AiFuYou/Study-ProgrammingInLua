--练习12.1：请编写一个函数，该函数返回指定日期和时间后恰好一个月的日期和时间(假定日期时间用数字形式表示)。

function GetTimeAfterOneMonth(time)
    local t = os.date("*t", time)
    t.month = t.month + 1
    return os.time(t)
end

print("Today is", os.date("%Y/%m/%d"))
print("One Month Later", os.date("%Y/%m/%d", GetTimeAfterOneMonth(os.time())))

--练习12.2：请编写一个函数，该函数返回指定日期是星期几(用整数表示,1表示星期天)。

function GetWeekday(y, m, d)
    local time = os.time({year = y, month = m, day = d})
    local t = os.date("*t", time)
    return os.date("%A", time), t.wday--直接使用表里的数据，或者使用%w将星期提取出来再+1（注意%w范围为0-6）
end

local tmpT = os.date("*t", os.time())
print("Today is", GetWeekday(tmpT.year, tmpT.month, tmpT.day))

--练习12.3：请编写一个函数，该函数的参数为一个日期和时间(使用数值表示)，返回当天中已经经过的秒数。

function GetToadyAlreadySec(time)
    local t = os.date("*t", time)
    t.hour = 0
    t.min = 0
    t.sec = 0
    return os.difftime(time, os.time(t))
end

print(string.format("%s seconds have passed today!", GetToadyAlreadySec(os.time())))

--练习12.4：请编写一个函数,该函数的参数为年，返回该年中第一个星期五是第几天。

function GetFirstFridayToDay(y)
    local t = os.date("*t", os.time({year = y, month = 1, day = 1}))
    local wday = t.wday
    local friday = 6
    return (wday <= friday and friday - wday or 6) + 1 --没必要使用while循环，简单计算一下即可
end

local year = 2021
print(string.format("The first Friday of year %s is the %s day", year, GetFirstFridayToDay(year)))

--练习12.5：请编写一个函数,该函数用于计算两个指定日期之间相差的天数。

function GetOffsetDays(date1, date2)
    return math.floor(os.difftime(os.time(date1), os.time(date2)) / (3600 * 24))
end

local date1 = os.date("*t")
local date2 = os.date("*t", os.time({year = date1.year, month = date1.month, day = date1.day + 10}))
print(GetOffsetDays(date2, date1))
--在上面的解答中，我们把day+10，但结果算出来是9，原因是date2没有设置小时分钟和秒

--练习12.6：请编写一个函数,该函数用于计算两个指定日期之间相差的月份。

function GetOffsetMonths(date1, date2)
    return date1.month - date2.month + (date1.year - date2.year) * 12
end

local date11 = os.date("*t")
local date22 = os.date("*t", os.time({year = date1.year, month = date1.month + 100, day = date1.day}))
print(GetOffsetMonths(date22, date11))

--练习12.7：向指定日期增加一个月再增加一天得到的结果，是否与先增加一天再增加一个月得到的结果相同?

--不一定相同，如下两种情况：

--day和month的相加之间不进行归一化，则结果相同
function test12_7_1()
    local d1 = os.date("*t", os.time({year = 2021, month = 5, day = 31}))--5.31
    d1.day = d1.day + 1
    d1.month = d1.month + 1
    local d2 = os.date("*t", os.time({year = 2021, month = 5, day = 31}))--5.31
    d2.month = d2.month + 1
    d2.day = d2.day + 1
    
    print(os.date("%c", os.time(d1)), os.date("%c", os.time(d2)), os.time(d1) == os.time(d2))
end

--day和month的相加之间进行归一化，则结果不一定相同
function test12_7_2()
    local d1 = os.date("*t", os.time({year = 2021, month = 5, day = 31}))--5.31
    d1.day = d1.day + 1
    d1 = os.date("*t", os.time(d1))
    d1.month = d1.month + 1
    local d2 = os.date("*t", os.time({year = 2021, month = 5, day = 31}))--5.31
    d2.month = d2.month + 1
    d2 = os.date("*t", os.time(d2))
    d2.day = d2.day + 1
    
    print(os.date("%c", os.time(d1)), os.date("%c", os.time(d2)), os.time(d1) == os.time(d2))
end

test12_7_1()
test12_7_2()

--日期增加一个月再减去一个月得到的结果不一定是原来的日期，如下：
local time1 = os.time({year = 2021, month = 3, day = 31})
local t1 = os.date("*t", time1)
t1.month = t1.month + 1--加一个月
local t2 = os.date("*t", os.time(t1))
t2.month = t2.month - 1--再减一个月

print("ori time", os.date("%c", time1))
print("add one month", os.date("%c", os.time(t1)))
print("then minus one month", os.date("%c", os.time(t2)))

--作者在书中做了解释，这种不一致是日历机制导致的结果，与Lua语言无关

--练习12.8：请编写一个函数,该函数用于输出操作系统的时区。

--方法一：转换成utc时间，然后进行计算
function GetTimeZone()
    local curTime = os.time()
    local utcTime = os.date("!*t", curTime)
    local t = os.date("*t", curTime)
    return math.floor(os.difftime(os.time(t), os.time(utcTime)) / 3600)
end
print("Current TimeZone is", GetTimeZone())

--方法二：直接使用os.date的%z指示符获取
function GetTimeZone2()
    return os.date("%z")--使用Lua5.4版本获取结果为：中国标准时间，所以如果要用来做计算还是使用上面的方法比较好
end
print("Current TimeZone is", GetTimeZone2())