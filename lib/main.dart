import 'package:flutter/material.dart';
import 'package:github_search/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Github Search',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: Home());
  }
}
