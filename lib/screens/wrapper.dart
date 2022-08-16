import 'package:flutter/material.dart';
import 'package:flutter_job_portal/screens/authenticate/authenticate.dart';
import 'package:flutter_job_portal/screens/ui/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_job_portal/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      print('not logged!');
      // return Authenticate();
      return Authenticate();
    } else {
      print('logged in!');
      return HomePage();
    }
  }
}
