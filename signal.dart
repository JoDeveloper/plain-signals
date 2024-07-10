Function? _subscriber = null;

class Signal {
  final subscribers = <Function>{};
  dynamic _state;
  Signal(value) {
    _state = value;
  }

  int get value {
    if (_subscriber != null) {
      subscribers.add(_subscriber!);
    }
    return _state;
  }

  set value(var val) {
    _state = val;
    subscribers.forEach((sub) => sub());
  }

  Function effect(Function callback) {
    _subscriber = callback;
    callback();
    _subscriber = null;

    return () => {
      subscribers.remove(callback)
    };
  }
}

void main() {
  final variable = Signal(0);
  
  
  
  final unsubscribe = variable.effect(()=>{
    print('count is ${variable.value}')
  });

  variable.value = 5;
  
  variable.value = 25;
  unsubscribe();
  variable.value = 35;

}
