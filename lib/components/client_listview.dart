import 'package:client_list_app/components/client_item.dart';
import 'package:client_list_app/data/dummy_data.dart';
import 'package:client_list_app/models/client.dart';
import 'package:client_list_app/models/client_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientListView extends StatelessWidget {
  const ClientListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<ClientList>(context);
    final List<Client> loadedClients = provider.items;
    

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25)
      ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: loadedClients.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: loadedClients[i],
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15),
                        height: size.height * 0.11,
                        child: ClientItem(loadedClients[i])),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
