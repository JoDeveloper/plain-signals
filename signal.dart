Function? _subscriber = null;

class Signal<T> {
  final subscribers = <Function>{};
  dynamic _state;
  Signal(value) {
    _state = value;
  }

  T get value {
    if (_subscriber != null) {
      subscribers.add(_subscriber!);
    }
    return _state;
  }

  set value(T val) {
    _state = val;
    subscribers.forEach((sub) => sub());
  }

  Function effect(Function callback) {
    _subscriber = callback;
    callback();
    _subscriber = null;

    return () => {subscribers.remove(callback)};
  }
}

void main() {
  final variable = Signal<int>(0);

  final unsubscribe =
      variable.effect(() => {print('count is ${variable.value}')});

  variable.effect(() {
    print(variable.value * 2);
  });

  variable.effect(() {
    print(variable.value * 3);
  });

  variable.value = 5;

  variable.value = 25;
  unsubscribe();
  variable.value = 35;
}
