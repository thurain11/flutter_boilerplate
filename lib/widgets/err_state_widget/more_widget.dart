



import '../../global.dart';

class MoreWidget extends StatelessWidget {

  Map<String,dynamic>? data;
  MoreWidget(this.data);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size.height * 0.2,
          ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      textStyle: TextStyle(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  onPressed: () {
                    // context.offAll(StarFishPage());
                  },
                  child: Text("BACK TO HOME",style: TextStyle(color: Colors.white),),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      textStyle: TextStyle(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  onPressed: () {
                    // context.offAll(StarFishPage());
                  },
                  child: Text("SEND REQUEST",style: TextStyle(color: Colors.white),),
                ),
              ],
            )
        ],
      ),
    );
  }
}
