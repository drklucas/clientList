import 'package:client_list_app/components/client_item.dart';
import 'package:client_list_app/components/client_listview.dart';
import 'package:client_list_app/components/search_bar.dart';
import 'package:client_list_app/data/dummy_data.dart';
import 'package:client_list_app/models/client.dart';
import 'package:client_list_app/models/client_list.dart';
import 'package:client_list_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({Key? key}) : super(key: key);

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  bool _isLoading = true;
  bool _isAlfabeticOrder = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ClientList>(context, listen: false).index('name').then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: SearchBar(),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextButton(
                    child: Text(
                      _isAlfabeticOrder ? 'A' : 'Nº',
                      style: const TextStyle(fontSize: 50, color: Colors.purple),
                    ),
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _isAlfabeticOrder = !_isAlfabeticOrder;
                      });
                       _isAlfabeticOrder 
                       ? Provider.of<ClientList>(
                        context,
                        listen: false,
                      ).index('name')
                      : Provider.of<ClientList>(
                        context,
                        listen: false,
                      ).index('id');
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                ),
                SizedBox(width: size.width * 0.1),
                SizedBox(
                  height: size.height * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: size.height * 0.15,
                        width: size.width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: const Text(
                                'Adicionar Cliente',
                                style:
                                    TextStyle(fontSize: 22, color: Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    AppRoutes.CLIENT_FORM);
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 7.0),
                              child: Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.72,
              width: size.width,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const ClientListView()
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
