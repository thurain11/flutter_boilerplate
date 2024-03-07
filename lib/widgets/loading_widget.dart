
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color color;
  LoadingWidget({this.size = 60, this.color = Colors.black54});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          width: size,
          height: size,
          child: CircularProgressIndicator(),

        ),
      ),
    );
  }
}



// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// import '../../globals.dart';
//
// class LoadingWidget extends StatelessWidget {
//   double size;
//   LoadingWidget({this.size = 35.0});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: Center(
//         child: Stack(
//           children: <Widget>[
//             Align(
//               alignment: Alignment.center,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(size),
//                 child: Container(
//                   width: size,
//                   height: size,
//                   child: Image.asset(
//                     "assets/icons/sm_logo.png",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               child: SpinKitDualRing(
//                 size: size,
//                 color: Theme.of(context).primaryColor,
//                 lineWidth: 2,
//               ),
//               alignment: Alignment.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
