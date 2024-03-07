
import '../../global.dart';

class ConnectionTimeoutWidget extends StatelessWidget {
  Function? fun;

  ConnectionTimeoutWidget({Key? key, this.fun}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.info_outline,
          color: Colors.red,
        ),
        const SizedBox(
          height: 20,
        ),
        const Center(child: Text("The connection has timeout....")),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              fun!();
            },
            child: const Text(
              "Try Again",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
