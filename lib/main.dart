import 'package:e_commerce_app/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(name: '/', page: () =>   const HomePage()),
        // Add more pages here, for example:
        // GetPage(name: '/second', page: () => SecondScreen()),
        // GetPage(name: '/third', page: () => ThirdScreen()),
      ],
      home:   HomePage(),
    );
  }
}
