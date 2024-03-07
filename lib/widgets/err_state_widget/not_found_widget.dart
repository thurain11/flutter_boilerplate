
import '../../global.dart';

class NotFoundWidget extends StatelessWidget {
  double? widgetSize;
  NotFoundWidget({this.widgetSize = 300});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
          child: Text('404 NOT FOUND',style: TextStyle(fontSize: 17),),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "Oops!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            "We couldn\'t find the page you looking for",
            textAlign: TextAlign.center,
          ),
        ),
//        Center(
//          child: RaisedButton(onPressed: () {
//            Navigator.of(context).pop();
//          },child: Text("Go Back"),color: Colors.teal,textColor: Colors.white,),
//        ),
      ],
    );
  }
}
