import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:myapp/cubit/bloc_observier.dart';
import 'package:myapp/screens/home_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
