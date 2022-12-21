import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mota_app/screens/analytics_screen.dart';
import 'package:mota_app/screens/data_historic_screen.dart';
import 'package:mota_app/screens/home_screen.dart';
import 'package:mota_app/widgets/graphic_widget.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 236, 255, 245),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color.fromARGB(255, 53, 161, 102),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 53, 161, 102), elevation: 0),
      ),
      initialRoute: 'home',
      routes: {
        'dataHistoric': (_) => const DataHistoricScreen(),
        'home': (_) => const HomeScreen(),
        // 'analytics': (_) => const AnalyticsScreen(),
      },
    );
  }
}
