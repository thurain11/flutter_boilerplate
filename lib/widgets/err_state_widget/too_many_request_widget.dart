

import '../../global.dart';

class TooManyRequestWidget extends StatelessWidget {
  Function? fun;

  TooManyRequestWidget({this.fun});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.info_outline,
          color: Colors.red,
        ),
        SizedBox(
          height: 20,
        ),
        Center(child: Text("Too Many Request! Please Try Again Later")),
      ],
    );
  }
}
