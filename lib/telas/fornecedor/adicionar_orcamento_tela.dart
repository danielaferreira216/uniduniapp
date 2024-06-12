import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdicionarOrcamentoTela extends StatefulWidget {
  @override
  _AdicionarOrcamentoTelaState createState() => _AdicionarOrcamentoTelaState();
}

class _AdicionarOrcamentoTelaState extends State<AdicionarOrcamentoTela> {
  final _formKey = GlobalKey<FormState>();
  final _nomeClienteController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();
  final _statusController = TextEditingController();

  void _adicionarOrcamento() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('orcamentos').add({
            'nomeCliente': _nomeClienteController.text,
            'descricao': _descricaoController.text,
            'valor': _valorController.text,
            'data': _dataController.text,
            'status': _statusController.text,
            'userId': user.uid,
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Orçamento adicionado com sucesso')));
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao adicionar orçamento: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Orçamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeClienteController,
                decoration: InputDecoration(labelText: 'Nome do Cliente'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do cliente';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataController,
                decoration: InputDecoration(labelText: 'Data'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o status';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarOrcamento,
                child: Text('Adicionar Orçamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}