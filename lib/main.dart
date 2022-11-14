import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/screens/auth_screen.dart';
import 'view/viewmodel/database_viewmodel.dart';
import 'view/viewmodel/auth_viewmodel.dart';

import 'view/viewmodel/local_storage_viewmodel.dart';
import 'view/screens/show_delivery_details_screen.dart';
import 'view/viewmodel/location_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<LocalStorageViewModel>(
          create: (context) => LocalStorageViewModel(),
        ),
        ListenableProvider<AuthViewModel>(
          create: (context) => AuthViewModel(),
        ),
        ListenableProvider<DatabaseViewModel>(
          create: (context) => DatabaseViewModel(),
        ),
        ListenableProvider<LocationViewModel>(
          create: (context) => LocationViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Consumer<LocalStorageViewModel>(
        builder: (context, localStorageViewModel, _) => FutureBuilder<bool?>(
          future: localStorageViewModel.getUserAuthenticationStatus(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == false) {
              return const AuthScreen();
            }
            return const ShowDeliveryDetailsScreen();
          },
        ),
      ),
    );
  }
}
