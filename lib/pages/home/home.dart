import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_setup/test_flutter_bloc/counter_cubit.dart';

import '../../global.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<CounterCubit, int>(
              builder: (context, state) {
                return Text(
                  '$state',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            // Card(child: Consumer<ThemeProvider>(
            //   builder: (con, ThemeProvider tm, child) {
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         DropdownButton(
            //           items: [
            //             DropdownMenuItem(
            //               child: Text("Light"),
            //               value: ThemeMode.light,
            //             ),
            //             DropdownMenuItem(child: Text("Dark"), value: ThemeMode.dark),
            //             DropdownMenuItem(child: Text("System"), value: ThemeMode.system),
            //           ],
            //           onChanged: (dynamic value) {
            //             if (value == ThemeMode.light) {
            //               tm.changeToLight();
            //             } else if (value == ThemeMode.dark) {
            //               tm.changeToDark();
            //             } else {
            //               tm.changeToSystem();
            //             }
            //           },
            //           value: tm.themeMode,
            //           underline: Container(),
            //         ),
            //       ],
            //     );
            //   },
            // )),
            ElevatedButton(
                onPressed: () {
                  context.read<CounterCubit>().increment();
                },
                child: Text("Increment")),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<CounterCubit>().decrement();
                },
                child: Text("Decrement")),
            // Text(
            //   "Hello",
            //   style: TextStyle(fontSize: 20),
            // ),
            // SizedBox(height: 20),
            // OutlinedButton(
            //     onPressed: () {
            //       context.read<CounterCubit>().increment();
            //     },
            //     child: Text("data")),
            // ListTile(
            //   onTap: () {},
            //   title: Text("Tilte"),
            //   subtitle: Text("Sub title"),
            //   trailing: IconButton(
            //       onPressed: () {
            //         context.read<CounterCubit>().decrement();
            //       },
            //       icon: Icon(Icons.home)),
            // )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
