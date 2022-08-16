import 'package:flutter/material.dart';
import 'package:flutter_job_portal/screens/ui/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_job_portal/models/user.dart';
import 'package:flutter_job_portal/service/auth.dart';
import 'package:flutter_job_portal/screens/wrapper.dart';

// import 'package:flutter_job_portal/news/model/article_model.dart';
// import 'package:flutter_job_portal/news/services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Network',
        theme: ThemeData.light(),
        // home: Wrapper(),

        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
