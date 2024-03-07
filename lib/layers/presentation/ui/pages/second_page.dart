

import 'package:flutter_setup/layers/bloc/counter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../global.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Page"),),
      body: StreamBuilder<int>(
        stream: bloc.stream,
        initialData: bloc.value,
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                snapshot.data != null ? Text(snapshot.data.toString()) : Container(),
                SizedBox(height: 40,),
                ElevatedButton(
                    onPressed: () async {
                      final List<AssetEntity>? result = await AssetPicker.pickAssets(
                        context,
                        pickerConfig: const AssetPickerConfig(),
                      );
                      // bloc.increment();
                  //context.go('/third_page');
                }, child: Text("Go to Third")),
                ElevatedButton(
                    onPressed: (){
                      bloc.decrement();
                      //context.go('/third_page');
                    }, child: Text("Go to Third")),
              ],
            ),
          );
        }
      ),
    );
  }



}

