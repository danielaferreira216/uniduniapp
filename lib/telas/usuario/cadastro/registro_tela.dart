import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistroTela extends StatefulWidget {
  @override
  _RegistroTelaState createState() => _RegistroTelaState();
}

class _RegistroTelaState extends State<RegistroTela> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _telefoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  void _registrar() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _senhaController.text,
        );

        await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid).set({
          'nome': _nomeController.text,
          'email': _emailController.text,
          'telefone': _telefoneController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário registrado com sucesso')));
        Navigator.pushNamed(context, '/complemento_cadastro');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.message}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Define o fundo branco
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50), // Espaço adicionado para balancear o layout
                  Text(
                    'Novo por aqui?',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Crie sua conta',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black, // Texto em preto para contraste com o fundo branco
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _telefoneController,
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [_telefoneMaskFormatter],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu telefone';
                      }
                      // Validação simples para o formato de telefone
                      if (!_telefoneMaskFormatter.isFill()) {
                        return 'Formato de telefone inválido. Ex: (xx) xxxxx-xxxx';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      // Validação para os critérios de segurança da senha
                      if (value.length < 8) {
                        return 'A senha deve ter pelo menos 8 caracteres';
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'A senha deve conter pelo menos uma letra maiúscula';
                      }
                      if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                        return 'A senha deve conter pelo menos um caractere especial (!@#\$&*~)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmarSenhaController,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme sua senha';
                      }
                      if (value != _senhaController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _registrar,
                    child: Text(
                      'Registrar',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text(
                      'Já tem uma conta? Faça login',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
