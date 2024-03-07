


import '../../core/database/share_pref.dart';
import '../../global.dart';

class NoLoginWidget extends StatelessWidget {

  String? message;
  NoLoginWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          child: Image.asset('assets/images/404.png'),
          width: 200,
          height: 200,
        ),
        SizedBox(
          height: 20,
        ),
        if (message != null) Center(child: Text(message ?? '')),
        Center(child: Text("You need to login to continue")),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Container(
            height: 25,
            child: ElevatedButton(
              onPressed: () {

              },
              child: Text("Login Here", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
