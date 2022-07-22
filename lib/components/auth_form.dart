import 'package:client_list_app/services/auth_service.dart';
import 'package:client_list_app/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final fPassKey = GlobalKey<FormState>();
  final fEmailKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLogin = true;
  late String title;
  late String actionButton;
  late String toggleButton;
  bool loading = false;
  bool isObscure = true;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool action) {
    setState(() {
      isLogin = action;
      if (isLogin) {
        title = 'Bem vindo ao seu';
        actionButton = 'Entrar';
        toggleButton = 'Ainda não é cliente? Cadastre-se';
      } else {
        title = 'Crie sua conta no';
        actionButton = 'Cadastrar';
        toggleButton = 'Já é cliente? Volte ao login';
      }
    });
  }

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  signup() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().signup(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      //color: Colors.white,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Olá, Farma!',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Text('aplicativo de saúde.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          Form(
            key: fEmailKey,
            child: Container(
              height: size.height * 0.075,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Color.fromARGB(255, 0, 238, 255),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  IconButton(onPressed: null, icon: Icon(Icons.clear))
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: fPassKey,
            child: Container(
              height: size.height * 0.075,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Color.fromARGB(120, 255, 255, 255),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: password,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: isObscure,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                      isObscure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  fPassKey.currentState?.reset();
                  if (fEmailKey.currentState!.validate()) {
                    _auth
                        .sendPasswordResetEmail(email: email.text)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Email enviado para ${email.text}')));
                    }).catchError((error) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(error.message)));
                    });
                  }
                },
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          Container(
            child: (loading)
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () {
                      if (fPassKey.currentState!.validate() &&
                          fEmailKey.currentState!.validate()) {
                        if (isLogin) {
                          print(isLogin);
                          login();
                        } else {
                          signup();
                        }
                      }
                    },
                    child: Text(actionButton),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 0, 238, 255),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () {
                      setFormAction(!isLogin);
                    },
                    child: Text(
                      toggleButton,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
