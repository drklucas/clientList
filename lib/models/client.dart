import 'dart:io';

import 'package:flutter/material.dart';

class Client with ChangeNotifier {
  final String id; 
  final String name; 
  final String image; 
  final String email; 
  final String cpf; 
  final String phone; 
  final String birthDate;
  final String sex;

  Client({
    required this.id, 
    required this.name, 
    required this.image, 
    required this.email, 
    required this.cpf, 
    required this.phone, 
    required this.birthDate, 
    required this.sex}); 

}
