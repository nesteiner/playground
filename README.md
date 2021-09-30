

# Program


## flatten dir

[goto project](./flatten_dir.py)  


### 介绍

将嵌套目录内的所有文件转移到某个目录  


### 用法

    python3 flatten_dir.py --from dirname --to dirname --method copy/move


## 链表制作新方式 written in Julia

[goto project](list.jl)  


### 说明

这是最近写出来的一个链表，使用的是 **一切皆类型**  
另外上个版本的 `C++` 链表文档我删了，懒得弄  
这里用 `Julia` 写一个精简的链表  


### 设计

首先为链表节点抽象出三个类型  

-   `ListNode` 表示最基本的链表节点类型
-   `ListNext <: ListNode` 表示拥有 `next` 成员的节点类型
-   `ListCons <: ListNext` 表示拥有 `data` 及 `next` 成员的节点类型

这三个类型各有其接口  

    next(node::ListNext) = node.next
    data(node::ListCons) = node.data
    insert_next!(node::ListNext, next::ListNode) = node.next = next

再由这三个类型派发出三种节点  

-   `Nil`
-   `Dummy`
-   `Cons`


    abstract type ListNode end
    abstract type ListNext <: ListNode end
    abstract type ListCons <: ListNext end
    
    mutable struct Nil <: ListNode
    
    end
    
    mutable struct Dummy <: ListNext
      next::ListNode
    
      Dummy() = new(Nil())
    end
    
    mutable struct Cons <: ListCons
      data::Int
      next::ListNode
    
      Cons(data::Int) = new(data, Nil())
    end


### 链表实现

在链表中的定义  

    mutable struct List
      dummy::Dummy
      current::ListNode
    end

`current` 节点表示可以遍历链表所有节点的游标节点，用 `ListNode` 抽象类型表示所有节点类型  
这样在内部的构造函数可以定义为  

    List() = begin
      list = new()
      list.current = list.dummy = Dummy()
      return list
    end

接下来操作节点需要用到运行时类型  

    function iterate(list::List)
      firstnode = next(list.dummy)
      if isa(firstnode, Nil)
        return nothing
      else
        return data(firstnode), next(firstnode)
      end
    end
    
    function iterate(list::List, state::ListNode)
      if isa(state, Nil)
        return nothing
      else
        return data(state), next(state)
      end
    end
    
    function push!(list::List, data::Int)
      newnode = Cons(data)
      unlink = next(list.current)
      insert_next!(newnode, unlink)
      insert_next!(list.current, newnode)
      list.current = next(list.current)
    end

这里尝试下一个测试案例  

    function show(io::IO, list::List)
      print(io, "list: ")
      for value in list
        print(io, value, ' ')
      end
    end
    
    function test()
      list = List()
      for i in 1:10
        push!(list, i)
      end
    
      println(list)
    end


# Clojure Simple Project


## Random function

[project dir](./random-clojure-function)  
command line application that displays a random function from the Clojure standard library  


## Clacks

[project dir](./cla)  
Encoding and decoding messages with Clacks  
我也不知道干什么使的，好像是灯语  


# Data Structure & Algorithm, using Julia


## LinkedList

[goto project](./list.jl)  
单链表结构，使用类型设计表达节点  


## 图 - 邻接表实现

[goto project](graphcpp/)  


### 内部结构


### 接口


### 实现算法


## 二叉树 - 以二叉搜索树为例

[goto project](treecpp/)  


### 内部结构


### 接口


### 实现算法


# Titanic

[read the doc](https://nesteiner.github.io/ChiniBlogs/html/titanic.html)  


## 数据探索


## 数据整理


### 缺失值填充

1.  **fill** <span class="underline">Embarked</span> with most frequent
2.  **drop** <span class="underline">Cabin</span>
3.  **fill** <span class="underline">Age</span> with mean 30


### 特征工程

1.  feature<sub>a</sub>

    -   **说明**  
        -   女性以及12岁以下儿童
        -   12岁以上男性
    -   **字段类型**  
        -   String
    -   **字段值**  
        -   A
        -   B
    
    -   注意  
        -   舍弃 Age 与 Sex

2.  feature<sub>b</sub>

    -   说明  
        -   家庭人员数量
    -   相关字段  
        -   SibSp
        -   Parch
    
    -   注意  
        -   舍弃 SibSp 与 Parch


### 特征量选取

-   Pclass
-   Fare
-   Embarked
-   feature<sub>a</sub>
-   feature<sub>b</sub>
-   Survived


### use MLJ pipeline

I need to use pipeline and some model to transform in **one step**  


### TODO something I forgot

-   have you tried **heatmap**


## 设计加工，重新整理


### 数据处理

1.  coerce scitype
2.  fill missing data
3.  generate new feature, including onehot encode, and coerce its own type
4.  drop unused feature


### 模型训练

-   use LogisticClassifier


### 生产环境调试

-   模型优化
-   图像查看产出结果


# Lab

[Ridge and Lasso regression](./lab6b.jl)  

