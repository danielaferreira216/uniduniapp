import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PesquisaTela extends StatefulWidget {
  @override
  _PesquisaTelaState createState() => _PesquisaTelaState();
}

class _PesquisaTelaState extends State<PesquisaTela> {
  final _searchController = TextEditingController();
  List<DocumentSnapshot> _servicos = [];
  String _categoriaSelecionada = 'Todos';

  void _pesquisarServicos() async {
    Query query = FirebaseFirestore.instance.collection('servicos');

    if (_searchController.text.isNotEmpty) {
      query = query.where('nome', isGreaterThanOrEqualTo: _searchController.text)
                   .where('nome', isLessThanOrEqualTo: '${_searchController.text}\uf8ff');
    }

    if (_categoriaSelecionada != 'Todos') {
      query = query.where('categoria', isEqualTo: _categoriaSelecionada);
    }

    QuerySnapshot querySnapshot = await query.get();

    setState(() {
      _servicos = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar Serviços'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _pesquisarServicos,
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _categoriaSelecionada,
              items: <String>['Todos', 'Buffet', 'Animação', 'Decoração'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _categoriaSelecionada = newValue!;
                  _pesquisarServicos();
                });
              },
            ),
            Expanded(
              child: _servicos.isEmpty
                  ? Center(child: Text('Nenhum serviço encontrado'))
                  : ListView.builder(
                      itemCount: _servicos.length,
                      itemBuilder: (context, index) {
                        var servico = _servicos[index];
                        return ListTile(
                          title: Text(servico['nome']),
                          subtitle: Text(servico['descricao']),
                          trailing: Text(servico['categoria']),
                        );
                      },
                    ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/orcamento');
              },
              child: Text('Ir para Orçamento'),
            ),
          ],
        ),
      ),
    );
  }
}
