import 'package:flutter_setup/core/utils/bloc_base.dart';
import 'package:flutter_setup/global.dart';

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;

  const BlocProvider({super.key, required this.bloc, required this.child});

  @override
  State<BlocProvider> createState() {
    return _BlocProviderState();
  }
  
}


class _BlocProviderState extends State<BlocProvider>{

  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  
}



