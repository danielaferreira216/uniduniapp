import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdicionarServicoAvulsoTela extends StatefulWidget {
  @override
  _AdicionarServicoAvulsoTelaState createState() => _AdicionarServicoAvulsoTelaState();
}

class _AdicionarServicoAvulsoTelaState extends State<AdicionarServicoAvulsoTela> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _disponibilidadeController = TextEditingController();

  void _adicionarServicoAvulso() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('servicos_avulsos').add({
            'nome': _nomeController.text,
            'descricao': _descricaoController.text,
            'preco': double.parse(_precoController.text),  // Converte para número
            'categoria': _categoriaController.text,
            'disponibilidade': _disponibilidadeController.text,
            'userId': user.uid,
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Serviço avulso adicionado com sucesso')));
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao adicionar serviço avulso: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Serviço Avulso'),
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
                controller: _precoController,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number, // Define o teclado numérico
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  // Validação para verificar se o valor é numérico
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um valor numérico válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoriaController,
                decoration: InputDecoration(labelText: 'Categoria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a categoria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _disponibilidadeController,
                decoration: InputDecoration(labelText: 'Disponibilidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a disponibilidade';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarServicoAvulso,
                child: Text('Adicionar Serviço Avulso'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
