import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tot/common/root_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    _App(),
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: RootTab());
  }
}
