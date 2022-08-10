import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/home_page.dart';
import 'package:todoapp/provider.dart';

import 'colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx)=>MyProvider()..createDataBase(),
      builder: (ctx,_) {
        var provider=Provider.of<MyProvider>(ctx);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode:provider.isDark?ThemeMode.dark:ThemeMode.light ,
        home: const HomePage(),
      );}
    );
  }
}

