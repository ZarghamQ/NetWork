import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[900],
        child: Center(
          //https://pub.dev/packages/flutter_spinkit -- follow link if you want to change spinner
                    // vvvvv // 
          child: SpinKitDualRing(color: Colors.indigoAccent, size: 50.0), // 
        ));
  }
}