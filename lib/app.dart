import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universities_proj/core/theme/theme.dart';
import 'package:universities_proj/universities/ui/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'GifsApp',
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.myTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
