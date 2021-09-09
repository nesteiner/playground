/*
  TODO check if base * can be assigned with derived *

 */
#include <iostream>
using std::cout;
using std::endl;

class base {
public:
  virtual void show() = 0;
};

class derived: public base {
public:
  derived() {}

public:
  void show() {
    cout << "hello world" << endl;
  }
};


int main() {
  base * pbase = new derived();
  pbase -> show();

  return 0;
}
