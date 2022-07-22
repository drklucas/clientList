import 'package:client_list_app/services/auth_service.dart';
import 'package:client_list_app/utils/app_routes.dart';
import 'package:client_list_app/views/clients_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/client_list.dart';

class SearchBar extends StatelessWidget {
  SearchBar({Key? key}) : super(key: key);

  TextEditingController txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final listScreen = ClientsListScreen();
    return Container(
      height: MediaQuery.of(context).size.height * 0.058,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: null,
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                fillColor: Colors.white,
                filled: false,
                hintText: 'Pesquisar',
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                labelStyle: TextStyle(color: Colors.grey),
              ),
              controller: txt,
              onChanged: (value) {},
            ),
          ),

          PopupMenuButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            itemBuilder: (contex) => [
              PopupMenuItem(
                onTap: () { 
                  context.read<AuthService>().logout();
                  },
                child: Row(
                  children: const [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                    Text(
                      'Sair do app',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
