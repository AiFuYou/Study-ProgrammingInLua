-- 练习3.1：以下哪些是有效的数值常量？它们的值分别是多少？
-- .0e12 .e12 0.0e 0x12 0xABFG 0xA FFFF 0xFFFFFFFF 0x 0x1P10 0.1e1 0x0.1p1
print(.0e12)--0.0
-- print(.e12)--无效，缺少小数部分
-- print(0.0e)--无效，缺少指数部份
print(0x12)--18
-- print(0xABFG)--无效，十六进制里没有G
print(0xA)--10
-- print(FFFF)--无效，是个有效的表示符，但不是有效的数值常量
print(0xFFFFFFFF)--4294967295
-- print(0x)--无效，没有十六进制的数字部份
print(0x1P10)--1024.0
print(0.1e1)--1.0
print(0x0.1p1)--0.125

-- 练习3.2：解释下列表达式之所以得出相应结果的原因。（注意： 整型算术运算总是会回环。）
-- > math.maxinteger * 2 --> -2
-- > math.mininteger * 2 --> 0
-- > math.maxinteger * math.maxinteger --> 1
-- > math.mininteger * math.mininteger --> 0

print(math.maxinteger * 2)--max = min - 1, max * 2 = max + min - 1 = max + min = -2
print(math.mininteger * 2)--min = max + 1, min * 2 = max * 2 + 2 = 0
print(math.maxinteger * math.maxinteger)--max = min - 1, max * max = (min - 1) * max = min * max - max = min - max = max + 1 - max = 1
print(math.mininteger * math.mininteger)--min = max + 1, min * min = (max + 1) * min = max * min + min = min + min = 0
-- 后两个计算中需要注意一点，math.maxinteger为奇数，math.mininteger，max * min，奇数个min相加结果为min

-- 练习3.3：下列代码的输出结果是什么？
for i = -10, 10 do
    print(i, i % 3)
end
-- -10 % 3 = 2
-- -10 // 3 = -4

-- 练习3.4：表达式2^3^4的值是什么？表达式2^-3^4呢？
print(2 ^ 3 ^ 4)--2.4178516392293e+024
print(2 ^ -3 ^ 4)--4.1359030627651e-025

-- 练习3.5：当分母是10的整数次幕时，数值12.7与表达式127/10相等。能否认为当分母是2的整数次幕时，这是一种通用规律？对于数值5.5情况又会怎样呢？
-- 翻译成人话：能把12.7表达为以2的整数次幂为分母的分数吗？能把5.5表达为以2的整数次幂为分母的分数吗？
-- 能，5.5也能
-- 12.7 = 25.4 / 2
-- 5.5 = 11 / 2
-- 没太明白这个题的用意是啥

-- 练习3.6：请编写一个通过高、母线与轴线的夹角来计算正圆锥体体积的函数。
-- 正圆锥体，母线是顶点到底部圆周任意点的线段，高就是轴
function GetConeVolumeByHAndAngle(h, angle)
    local r = math.tan(math.rad(angle)) * h
    return math.pi * r ^ 2 * h / 3
end

-- 练习3.7：利用函数math.random编写一个生成遵循正态分布（高斯分布）的伪随机数发生器。
-- 说实话，这个题有点超纲，等研究懂了之后再来补充
