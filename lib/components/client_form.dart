import 'dart:io';

import 'package:client_list_app/models/client.dart';
import 'package:client_list_app/models/client_list.dart';
import 'package:client_list_app/utils/app_routes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ClientForm extends StatefulWidget {
  const ClientForm({Key? key}) : super(key: key);

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = false;

  late String ref;
  String loadedImageUrl = '';
  String noImgUrl =
      'https://www.auctus.com.br/wp-content/uploads/2017/09/sem-imagem-avatar.png';

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, String>();
  final MaskedTextController _phoneMask =
      MaskedTextController(mask: '(00)00000-0000');
  final MaskedTextController _cpfMask =
      MaskedTextController(mask: '000.000.000-00');
  final MaskedTextController _dateMask =
      MaskedTextController(mask: '00/00/0000');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final client = arg as Client;
        _formData['id'] = client.id;
        _formData['name'] = client.name;
        _formData['image'] = client.image;
        _formData['email'] = client.email;
        _formData['cpf'] = client.cpf;
        _formData['phone'] = client.phone;
        _formData['birthDate'] = client.birthDate;
        _formData['sex'] = client.sex;
      }
    }
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => loading = true);

    try {
      await Provider.of<ClientList>(
        context,
        listen: false,
      ).saveClient(_formData);

      Navigator.of(context).pushReplacementNamed(AppRoutes.CLIENT_LIST);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Não foi possível salvar os dados do cliente!'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> upload(String path) async {
    ref = '';
    File file = File(path);
    try {
      ref = 'images/img-${DateTime.now().toString()}.jpg';
      await storage.ref(ref).putFile(file);
      storage
          .ref(ref)
          .putFile(file)
          .snapshot
          .ref
          .getDownloadURL()
          .then((urlImage) {
        print(urlImage);
        _formData['image'] = urlImage;
        setState(() {
          loadedImageUrl = urlImage;
        });
      });
    } on FirebaseException catch (e) {
      throw Exception('Erro ao enviar imagem: ${e.code}');
    }
  }

  pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      await upload(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade100,
        ),
      ),
      Positioned(
        top: 24.0,
        left: 0.0,
        right: 0.0,
        child: Container(
          height: size.height * 0.325,
          decoration: BoxDecoration(
              color: Colors.purple.shade900,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.CLIENT_LIST, (route) => false);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _submitForm,
                    icon: const Icon(
                      Icons.pending_actions_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                child: Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: _formData['image'] == null
                          ? NetworkImage(noImgUrl)
                          : NetworkImage(_formData['image'].toString()),
                    ),
                  ),
                ),
                onTap: pickAndUploadImage,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 200.0,
        left: 25.0,
        right: 25.0,
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: InputDecoration(
                        labelText: 'Nome completo',
                        labelStyle: TextStyle(
                            color: Colors.purple.shade900,
                            fontWeight: FontWeight.w500),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (_name) {
                        final name = _name ?? '';

                        if (name.trim().isEmpty) {
                          return 'Insira um nome!';
                        }

                        if (name.trim().length < 3) {
                          return 'Insira um nome válido (min. 3 letras).';
                        }

                        return null;
                      }
                    ),
                  TextFormField(
                      initialValue: _formData['email']?.toString(),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Colors.purple.shade900,
                            fontWeight: FontWeight.w500),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSaved: (email) => _formData['email'] = email ?? '',
                      validator: (_email) {
                        final email = _email ?? '';

                        if (email.trim().isEmpty) {
                          return 'Insira um email!';
                        }
                        if (email.trim().length < 4) {
                          return 'Insira um email válido';
                        }
                        if (!email.contains('@')) {
                          return 'Informe um email válido';
                        }
                        return null;
                      }),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              initialValue: _formData['phone']?.toString(),
                              decoration: InputDecoration(
                                labelText: 'Telefone',
                                labelStyle: TextStyle(
                                    color: Colors.purple.shade900,
                                    fontWeight: FontWeight.w500),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              controller: _formData['phone']?.toString() == null
                                  ? _phoneMask
                                  : null,
                              onSaved: (phone) => _formData['phone'] =
                                  _formData['phone']?.toString() ??
                                      _phoneMask.text,
                              validator: (_phone) {
                                final phone = _phone ?? '';

                                if (phone.trim().isEmpty) {
                                  return 'Insira um número de telefone';
                                }
                                if (phone.length < 14) {
                                  return 'Insira um número com DDD + 9 dígitos';
                                }
                                return null;
                              }),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                              initialValue: _formData['cpf']?.toString(),
                              controller: _formData['cpf']?.toString() == null
                                  ? _cpfMask
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'CPF',
                                labelStyle: TextStyle(
                                    color: Colors.purple.shade900,
                                    fontWeight: FontWeight.w500),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              onSaved: (cpf) => _formData['cpf'] =
                                  _formData['cpf']?.toString() ?? _cpfMask.text,
                              validator: (_cpf) {
                                final cpf = _cpf ?? '';

                                if (cpf.trim().isEmpty) {
                                  return 'Insira um cpf!';
                                }
                                if (cpf.length < 14) {
                                  return 'Insira um cpf válido';
                                }
                                return null;
                              }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          'Data de Nascimento',
                          style: TextStyle(
                              color: Colors.purple.shade900,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                            initialValue: _formData['birthDate']?.toString(),
                            decoration: InputDecoration(
                              labelText: 'DD/MM/AAAA',
                              labelStyle: TextStyle(
                                  color: Colors.purple.shade900,
                                  fontWeight: FontWeight.w500),
                            ),
                            controller:
                                _formData['birthDate']?.toString() == null
                                    ? _dateMask
                                    : null,
                            textInputAction: TextInputAction.next,
                            onSaved: (birthDate) =>
                                _formData['birthDate'] = birthDate ?? '',
                            validator: (_birthDate) {
                              final birthDate = _birthDate ?? '';

                              if (birthDate.trim().isEmpty) {
                                return 'Insira sua Data de Nascimeneto';
                              }
                              return null;
                            }),
                      ),
                    ]),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, top: 5),
                                child: Text(
                                  'Sexo',
                                  style: TextStyle(
                                      color: Colors.purple.shade900,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              DropdownButtonFormField(
                                hint: _formData['sex']?.toString() != null
                                    ? null
                                    : Text(
                                        'Selecione',
                                        style: TextStyle(
                                            color: Colors.purple.shade900,
                                            fontWeight: FontWeight.w500),
                                      ),
                                value: _formData['sex']?.toString(),
                                onChanged: (value) {
                                  _formData['sex'] = value.toString();
                                },
                                items: [
                                  DropdownMenuItem(
                                    child: Text(
                                      'Masculino',
                                      style: TextStyle(
                                          color: Colors.purple.shade900,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    value: 'Masculino',
                                  ),
                                  DropdownMenuItem(
                                    child: Text(
                                      'Feminino',
                                      style: TextStyle(
                                          color: Colors.purple.shade900,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    value: 'Feminino',
                                  ),
                                ],
                                validator: (sex) {
                                  if (sex == null) {
                                    return 'Selecione o sexo';
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
