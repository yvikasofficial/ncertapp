import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Providers/AuthProvider.dart';
import 'package:ncrtapp/Screens/HomePages/SplashPage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize("ca-app-pub-6664170669649435~3283239589");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<AdminProvider>(
          create: (context) => AdminProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Ncrt App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          fontFamily: 'SF',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage2(),
      ),
    );
  }
}
