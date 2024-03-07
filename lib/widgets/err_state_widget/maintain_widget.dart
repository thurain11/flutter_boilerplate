

import '../../global.dart';

class ServerMaintenance extends StatelessWidget {
  final Function? fun;
  final double? widgetSize;

  ServerMaintenance({this.fun, this.widgetSize = 200});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(child: Container(child: Image.asset("assets/images/503.png"), width: widgetSize, height: widgetSize)),
          SizedBox(height: 10),
          Center(
            child: Text(
              "System Maintenance...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ),
          Center(child: Text("Service Unavailable", style: TextStyle(fontSize: 15))),
          // SizedBox(
          //   height: 20,
          // ),
          // Center(
          //   child: Container(
          //     height: 25,
          //     child: ElevatedButton(
          //       onPressed: ()
          //         fun();
          //       },
          //       child: Text("Try Again"),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
