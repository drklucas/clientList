import 'package:client_list_app/services/auth_service.dart';
import 'package:client_list_app/views/auth_screen.dart';
import 'package:client_list_app/views/clients_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {

  const AuthCheck({ Key? key }) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {

   @override
   Widget build(BuildContext context) {
     AuthService auth = Provider.of<AuthService>(context);

     if(auth.isLoading)
     return loading();
     else if (auth.usuario == null)
     return AuthScreen();
     else 
     return ClientsListScreen();
   }
      loading() {
        return const Scaffold(
           body: Center(
             child: CircularProgressIndicator(),
           ),
       );
      }
       
  }
