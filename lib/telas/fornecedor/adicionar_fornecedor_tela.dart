import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdicionarFornecedorTela extends StatefulWidget {
  @override
  _AdicionarFornecedorTelaState createState() => _AdicionarFornecedorTelaState();
}

class _AdicionarFornecedorTelaState extends State<AdicionarFornecedorTela> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _empresaController = TextEditingController();
  final _servicosController = TextEditingController();

  void _adicionarFornecedor() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('fornecedores').add({
            'nome': _nomeController.text,
            'email': _emailController.text,
            'telefone': _telefoneController.text,
            'empresa': _empresaController.text,
            'servicos': _servicosController.text,
            'userId': user.uid,
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fornecedor adicionado com sucesso')));
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao adicionar fornecedor: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Fornecedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _empresaController,
                decoration: InputDecoration(labelText: 'Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a empresa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _servicosController,
                decoration: InputDecoration(labelText: 'Serviços'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira os serviços';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarFornecedor,
                child: Text('Adicionar Fornecedor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
