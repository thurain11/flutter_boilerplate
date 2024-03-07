


import 'package:flutter_setup/core/utils/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc implements BlocBase{

  int _value = 0;
  int get value => _value;

    PublishSubject<int> _controller = PublishSubject();
    Stream<int> get stream => _controller.stream;

   CounterBloc(){
     _controller.add(_value);
   }

   void increment(){
      _value = _value+1;
      _controller.add(_value);
   }

  void decrement(){
    _value = _value-1;
    _controller.add(_value);
  }


  @override
  void dispose() {
     _controller.close();
  }

}


CounterBloc bloc = CounterBloc();

