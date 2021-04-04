import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/components/uber_router.dart';
import 'package:uber_clone/providers/profile_pictures_provider.dart';
import 'package:uber_clone/providers/user_data_provider.dart';
import 'package:uber_clone/services/firebase/authentication_service.dart';
import 'package:uber_clone/theme/theme.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('main app rebuilded');
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (context) => AuthenticationService(),
        ),
        StreamProvider(
          initialData: null,
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        ),
        ChangeNotifierProvider(
          create: (context) => ProfilePicturesProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => UserDataProvider(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.appTheme(),
        initialRoute: '/',
        onGenerateRoute: UberRouter.generateRoute,
      ),
    );
  }
}

