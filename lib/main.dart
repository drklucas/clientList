import 'package:client_list_app/components/auth_check.dart';
import 'package:client_list_app/models/client_list.dart';
import 'package:client_list_app/services/auth_service.dart';
import 'package:client_list_app/utils/app_routes.dart';
import 'package:client_list_app/views/auth_screen.dart';
import 'package:client_list_app/views/client_form_screen.dart';
import 'package:client_list_app/views/clients_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
 
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ClientList(
          auth: context.read<AuthService>(),
        )),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          
          primarySwatch: Colors.blue,
        ),
        home: AuthCheck(),
        routes: {
          AppRoutes.CLIENT_FORM: (ctx) => ClientFormScreen(),
          AppRoutes.CLIENT_LIST: (ctx) => ClientsListScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
