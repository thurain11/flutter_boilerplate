

import '../../global.dart';

class NoInternetWidget extends StatelessWidget {
  Function? fun;
  double? imgSize;
  NoInternetWidget({this.fun, this.imgSize = 90});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              // child: Lottie.asset("assets/anim/no-internet.json"),
              child: Text("No Internet Widget"),
              width: imgSize,
              height: imgSize,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "No Connection",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "Check your internet connection and try again!",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 25,
                  child: ElevatedButton(
                    onPressed: () {
                      // AppSettings.openAppSettings(type: );
                    },
                    child: Text(
                      "Wifi Setting",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          // Center(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Theme.of(context).cardColor,
          //     ),
          //     child: IconButton(
          //       onPressed: ()=> context.back(),
          //       icon: Icon(Platform.isIOS? CupertinoIcons.back: Icons.arrow_back),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
