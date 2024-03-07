import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../global.dart';


class InternetProvider extends ChangeNotifier {


  bool isInternet = true;

  Future<void> execute() async {

    final bool isConnected = await InternetConnectionChecker().hasConnection;

    final StreamSubscription<InternetConnectionStatus> listener =
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            isInternet = true;

            notifyListeners();
            break;
          case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
            isInternet = false;
            notifyListeners();
            break;
        }
      },
    );


  }

}