import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibe/ui/components/theme.dart';
import 'package:vibe/ui/pages/login/login_page.dart';
import 'package:vibe/ui/pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      title: 'vibe',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: LoginPage(null),
    );
  }
}
