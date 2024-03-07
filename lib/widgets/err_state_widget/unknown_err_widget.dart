

import '../../global.dart';

class UnknownErrWidget extends StatelessWidget {
  Function? fun;
  String? message;
  double? widgetSize;

  UnknownErrWidget({this.fun, this.message, this.widgetSize = 300});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
          child: Container(
            child: Image.asset("assets/images/unknown.png", errorBuilder: (c, s, t) {
              return Icon(
                Icons.info_outline,
                color: Colors.grey,
              );
            }),
            width: widgetSize,
            height: widgetSize,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
            child: message == null
                ? Text(
                    "Unknown Error!...",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : Text(
                    message!,
                    textAlign: TextAlign.center,
                  )),
        SizedBox(
          height: 20,
        ),
        fun == null
            ? Container()
            : Center(
                child: Container(
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
              ),
      ],
    );
  }
}
