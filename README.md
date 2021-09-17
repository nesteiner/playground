

# Program


## flatten dir

[goto project](./flatten_dir.py)  


### 介绍

将嵌套目录内的所有文件转移到某个目录  


### 用法

    python3 flatten_dir.py --from dirname --to dirname --method copy/move


## C++ list 制作新方式

[goto project](./listcpp)  


### 说明

链表其实我写过好多次了，最近发现现代语言有种保证运行安全的方法，叫做 **一切皆类型**  
刚好 Julia 语言就是这么一个实现，有人已经类型安全，避开使用空值来实现链表，这里我想用 C++ 试一试  


### 设计

首先定义 抽象类/接口类 listnode , 并分发出三个子类 nullnode, dummynode, datanode， 分别重写接口的方法  
这样以后，可以通过 listnode \* 调用抽象类方法来实现 **多态**  

    class listnode {
    public:
      virtual listnode * next_node() = 0;
      virtual void insert_next(listnode * pnode) = 0;
      virtual bool isnull() = 0;
      virtual int getdata() = 0;
    
    };

    class nullnode : public listnode {
    public:
      nullnode() {}
    
    public:
      listnode * next_node() {
        throw implException("next node is not implied for nullnode type");
      }
    
      void insert_next(listnode * node) {
        throw implException("insert_next is not implied for nullnode type");
      }
    
    
      bool isnull() { return true; }
    
      int getdata() {
        throw implException("getdata is not implied for nullnode type");
      }
    };
    
    class dummynode : public listnode {
    private:
      listnode * pnext;
    
    public:
      dummynode(listnode * pnode): pnext(pnode) {}
    
    public:
      listnode * next_node() { return pnext; }
    
      void insert_next(listnode * pnode) { pnext = pnode; }
    
      bool isnull() { return false; }
    
      int getdata() {
        throw implException("getdata is not implied for dummynode type");
      }
    };
    
    class datanode : public listnode {
    private:
      int data;
      listnode * pnext;
    
    public:
      datanode(int _data, listnode * _pnext) : data(_data), pnext(_pnext) {}
    
    public:
      listnode * next_node() { return pnext; }
    
      void insert_next(listnode * pnode) { pnext = pnode; }
    
      bool isnull() { return false; }
    
      int getdata() { return data; }
    };

**注意**  
如果使用 Rust 中的枚举类型来描述 listnode 下的子类，应该更为合理  


### 链表定义

链表节点的插入会用到 哨兵节点，也就是 dummynode 类型  
另外要额外定义一个 nullnode 对象来表示 **空指针**  

    static nullnode null = nullnode();

    class list {
    private:
      listnode * phead;
      listnode * ptail;
    
    public:
      list() {
        phead = ptail = new dummynode(&null);
      }
    
      ~list() {
        listnode * pnode = phead;
        listnode * prev = nullptr;
        while(!pnode -> isnull()) {
          prev = pnode;
          pnode = pnode -> next_node();
    
          delete prev;
        }
      }
    
    public:
      void push(int data) {
        datanode * pnode = new datanode(data, &null);
        ptail -> insert_next(pnode);
        ptail = ptail -> next_node();
      }
    
      friend ostream &operator<<(ostream &os, list &lst) {
        listnode * pnode = lst.phead -> next_node();
        while (!pnode -> isnull()) {
          os << pnode -> getdata() << ' ';
          pnode = pnode -> next_node();
        }
        return os;
      }
    };


### 测试实例

    int main() {
      list lst;
      for(int i = 0; i <= 10; i += 1) {
        lst.push(i);
      }
    
      cout << lst << endl;
      return 0;
    }

运行结果  

> 0 1 2 3 4 5 6 7 8 9 10  


# Clojure Simple Project


## Random function

[project dir](./random-clojure-function)  
command line application that displays a random function from the Clojure standard library  


## Clacks

[project dir](./cla)  
Encoding and decoding messages with Clacks  
我也不知道干什么使的，好像是灯语  


# Julia Data Structures


## LinkedList

[goto project](./list.jl)  
单链表结构，使用类型设计表达节点  


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

