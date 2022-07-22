import 'package:client_list_app/components/client_form.dart';
import 'package:flutter/material.dart';


class ClientFormScreen extends StatelessWidget {
  const ClientFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.shade100,
          ),
          child: ClientForm()),
    );
  }
}
