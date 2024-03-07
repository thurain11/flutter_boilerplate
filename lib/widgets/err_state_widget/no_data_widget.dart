

import '../../global.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: ListView(
        children: [
          SizedBox(
            height: size.height * 0.20,
          ),
          Container(
            child: Image.asset('assets/images/empty_message.png',),
            width: 150,
            height: 150,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "No Data",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
