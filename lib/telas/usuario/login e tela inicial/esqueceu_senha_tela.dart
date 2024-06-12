import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EsqueceuSenhaTela extends StatefulWidget {
  @override
  _EsqueceuSenhaTelaState createState() => _EsqueceuSenhaTelaState();
}

class _EsqueceuSenhaTelaState extends State<EsqueceuSenhaTela> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _resetSenha() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email de redefinição de senha enviado!')));
        Navigator.pushNamed(context, '/');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.message}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esqueceu a Senha'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetSenha,
                child: Text('Redefinir Senha'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
