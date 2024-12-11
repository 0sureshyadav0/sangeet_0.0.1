import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sangeet/providers/music_provider.dart';

import 'package:sangeet/screens/music_list.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => MusicProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sangeet',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: GoogleFonts.playfairDisplay().fontFamily),
      home: const MusicListScreen(),
    );
  }
}
