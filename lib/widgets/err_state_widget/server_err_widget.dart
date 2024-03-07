

import '../../global.dart';

class ServerErrWidget extends StatelessWidget {
  final Function? fun;
  final double? widgetSize;

  ServerErrWidget({this.fun, this.widgetSize = 300});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
          child: Text('500 INTERNAL SERVER ERROR!', style: TextStyle(fontSize: 18)),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Column(
            children: [
              Container(
                height: 25,
                child: ElevatedButton(
                  onPressed: () {
                    fun!();
                  },
                  child: Text(
                    "Try Again",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // if (Platform.isIOS)
              //   Container(
              //     height: 25,
              //     margin: EdgeInsets.only(top: 10),
              //     child: ElevatedButton.icon(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //       icon: Icon(
              //         Icons.arrow_back_ios,
              //         size: 18,
              //         color: Colors.white,
              //       ),
              //       label: Text(
              //         "Back",
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     ),
              //   ),
            ],
          ),
        )
      ],
    );
  }
}
