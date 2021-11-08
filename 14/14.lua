function printMatrix(matrix)
    for i = 1, #matrix do
        print("{" .. table.concat(matrix[i], ", ") .. "},")
    end
end

--练习14.1：请编写一个函数，该函数用于两个稀疏矩阵相加。

function add(a, b)
    assert(type(a) == "table")
    assert(type(b) == "table")
    assert(#a == #b, "a and b are not the same length!")

    local n = #a
    local c = {}

    for i = 1, n do
        local va = a[i]
        local vb = b[i]

        c[i] = {}
        
        for k, v in pairs(va) do
            c[i][k] = (c[i][k] or 0) + v--一定要注意这里or运算要加括号，否则会先计算0 + v
        end

        for k, v in pairs(vb) do
            c[i][k] = (c[i][k] or 0) + v
        end
    end

    return c
end

local ta = {
    {1, 2, 3},
    {4, nil, 6}
}
local tb = {
    {4, 5, nil},
    {7, 8, 9}
}

printMatrix(add(ta, tb))

--练习14.2：改写示例14.2中队列的实现，使得当队列为空时两个索引都返回0。

local queue = {}

function queue.new()
    return {first = 0, last = 0}
end

function queue.isEmpty(list)
    return list.first == list.last and list[list.first] == nil--注意判空条件，只有索引相等，且当前索引在list中的值为nil时队列为空
end

function queue.pushFirst(list, value)
    if queue.isEmpty(list) then
        list.last = list.last - 1
    end
    
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function queue.pushLast(list, value)
    if queue.isEmpty(list) then
        list.first = list.first + 1
    end
    
    local last = list.last + 1
    list.last = last
    list[last] = value
end

function queue.popFirst(list)
    if queue.isEmpty(list) then return nil end
    
    local v = list[list.first]
    if list.first == list.last then
        list.first = 0
        list.last = 0
    else
        list.first = list.first + 1 
    end

    return v
end

function queue.popLast(list)
    if queue.isEmpty(list) then return nil end
    
    local v = list[list.last]
    if list.first == list.last then
        list.first = 0
        list.last = 0
    else
        list.last = list.last - 1
    end
    
    return v
end

local t2 = queue.new()
queue.pushFirst(t2, 11)
queue.pushLast(t2, 12)
print(queue.popFirst(t2), queue.popFirst(t2), t2.first, t2.last)

--练习14.3：修改图所用的数据结构，使得图可以保存每条边的标签。该数据结构应该使用包括两个字段的对象来表示每一条边，即边的标签和边指向的节点。
--与邻接集合不同，每一个节点保存的是从当前结点出发的边的集合。
--修改函数readgraph，使得该函数从输入文件中按行读取，每行由两个节点名称外加边的标签组成（假设标签是一个数字）。

function name2node(graph, name)
    local node = graph[name]
    if not node then
        node = {name = name, adj = {}}
        graph[name] = node
    end
    return node
end

function readgraph()
    local graph = {}
    for line in io.lines() do
        local namefrom, nameto, distance = string.match(line, "(%S)%s+(%S)%s+(%d+)")
        local from = name2node(graph, namefrom)
        local to = name2node(graph, nameto)
        from.adj[to] = distance
    end
    return graph
end

--练习14.4：假设图使用上一个练习的表示方式，其中边的标签代表两个终端节点之间的距离。
--请编写一个函数，使用Dijkstra算法寻找两个指定节点之间的最短路径。
--Dijkstra算法详情：https://zhuanlan.zhihu.com/p/40338107

function Dijkstra(graph, startName, endName)
    local distance = {}
    for _, v in pairs(graph) do
        distance[v] = math.maxinteger
    end

    local path = {}
    local visited = {}

    local startNode = name2node(graph, startName)
    local endNode = name2node(graph, endName)
    local curNode = startNode
    distance[startNode] = 0

    while curNode ~= endNode do
        local minDis
        local nextNode
        for to, d in pairs(curNode.adj) do
            if not visited[to] then
                local tmpD = distance[curNode] + d
                if not minDis then
                    minDis = tmpD
                    nextNode = to
                else
                    if minDis > tmpD then
                        minDis = tmpD
                        nextNode = to
                    end
                end

                if distance[to] > tmpD then
                    distance[to] = tmpD
                    path[to] = curNode
                end
            end
        end
        visited[curNode] = true
        
        for name, node in pairs(graph) do
            if not visited[node] then
                if not nextNode then
                    nextNode = node
                else
                    if distance[node] < distance[nextNode] then
                        nextNode = node
                    end
                end
            end
        end
        curNode = nextNode
    end

    local traceback = {}
    curNode = endNode
    while curNode ~= startNode do
        traceback[#traceback + 1] = curNode
        curNode = path[curNode]
    end
    traceback[#traceback + 1] = startNode

    for i = #traceback, 1, -1 do
        local cur = traceback[i]
        local next = traceback[i - 1]
        if next then
            io.write(cur.name, "-", cur.adj[next], "-")
        else
            io.write(cur.name, "\n")
        end
    end
end

io.input("14.txt")
Dijkstra(readgraph(), "a", "e")--求a到e最短路径

io.input("graph.txt")
Dijkstra(readgraph(), "a", "e")--求a到e最短路径








