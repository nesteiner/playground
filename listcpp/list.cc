#include <exception>
#include <iostream>
#include <ostream>
using std::cout;
using std::endl;
using std::exception;
using std::ostream;
using std::string;

class implException : public exception {
private:
  string message;

public:
  implException(const char *_message) : message(_message) {}
  const char *what() const throw() { return message.data(); }
};

class listnode;
class nullnode;
class dummynode;
class datanode;

class listnode {
public:
  virtual listnode * next_node() = 0;
  virtual void insert_next(listnode * pnode) = 0;
  // virtual void jump_next() = 0;
  virtual bool isnull() = 0;
  virtual int getdata() = 0;
  // virtual ~listnode() = 0
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

  // void jump_next() {
  //   throw implException("jump_next is not implied for nullnode type");
  // }

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

  // void jump_next() { this = this -> pnext; }

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

  // void jump_next() { this = this -> pnext; }

  bool isnull() { return false; }

  int getdata() { return data; }
};

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

int main() {
  list lst;
  for(int i = 0; i <= 10; i += 1) {
    lst.push(i);
  }

  cout << lst << endl;
  return 0;
}
