import 'dart:math';

import 'package:client_list_app/data/dummy_data.dart';
import 'package:client_list_app/databases/db_firestore.dart';
import 'package:client_list_app/models/client.dart';
import 'package:client_list_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientList with ChangeNotifier {
  List<Client> _items = [];
  late FirebaseFirestore db;
  late AuthService auth;

  List<Client> get items => [..._items];

  ClientList({required this.auth}) {
    _startList();
  }

  int get itemsCount {
    return _items.length;
  }

  _startList() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  Future<void> index(String order) async {
    _items.clear();
    var clientsList =
        await db
        .collection('usuarios/${auth.usuario!.uid}/clients')
        .orderBy(order)
        .get();

    

    for (var client in clientsList.docs) {
      _items.add(
        Client(
          id: client['id'],
          name: client['name'],
          image: client['image'],
          email: client['email'],
          cpf: client['cpf'],
          phone: client['phone'],
          birthDate: client['birthDate'],
          sex: client['sex'],
        ),
      );
    }
    notifyListeners();
  }

  Future<void> saveClient(Map<String, Object> data) async {
    bool hasId = data['id'] != null;

    final client = Client(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      image: data['image'] as String,
      email: data['email'] as String,
      cpf: data['cpf'] as String,
      phone: data['phone'] as String,
      birthDate: data['birthDate'] as String,
      sex: data['sex'] as String,
    );

    if (hasId) {
      return update(client);
    } else {
      return store(client);
    }
  }

  Future<void> store(Client client) async {
    db
        .collection('usuarios/${auth.usuario!.uid}/clients')
        .doc(client.id)
        .set({
          'id': client.id,
          'name': client.name,
          'image': client.image,
          'email': client.email,
          'cpf': client.cpf,
          'phone': client.phone,
          'birthDate': client.birthDate,
          'sex': client.sex,
        })
        .then((value) => print('Client saved on Firebase!...'))
        .catchError((error) => print('An error ocurred: $error'));
  }

  Future<void> update(Client client) async {
    db
        .collection('usuarios/${auth.usuario!.uid}/clients')
        .doc(client.id)
        .set({
          'id': client.id,
          'name': client.name,
          'image': client.image,
          'email': client.email,
          'cpf': client.cpf,
          'phone': client.phone,
          'birthDate': client.birthDate,
          'sex': client.sex,
        })
        .then((value) => print('Client updated on Firebase!...'))
        .catchError((error) => print('An error ocurred: $error'));
  }

  Future<void> delete(String clientId) async {
    db
        .collection('usuarios/${auth.usuario!.uid}/clients')
        .doc(clientId)
        .delete()
        .then((value) => print('Client excluded...'))
        .catchError((error) => print('An error ocurred: $error'));
    index('name');
    notifyListeners();
  }
}
