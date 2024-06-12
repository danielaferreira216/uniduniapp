import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuffetCompletoTela extends StatefulWidget {
  @override
  _BuffetCompletoTelaState createState() => _BuffetCompletoTelaState();
}

class _BuffetCompletoTelaState extends State<BuffetCompletoTela> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _fornecedores = [];
  List<DocumentSnapshot> _filteredFornecedores = [];

  @override
  void initState() {
    super.initState();
    _carregarFornecedores();
  }

  void _carregarFornecedores() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('fornecedores').get();
    setState(() {
      _fornecedores = querySnapshot.docs;
      _filteredFornecedores = _fornecedores;
    });
  }

  void _filtrarFornecedores() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFornecedores = _fornecedores.where((fornecedor) {
        return fornecedor['nome'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _filtrarPor(String criterio) {
    // Adicione a lógica para filtrar por critério (domicílio, promoções, avaliação)
  }

  void _abrirMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Dados Pessoais'),
                onTap: () {
                  Navigator.pushNamed(context, '/dados_pessoais');
                },
              ),
              ListTile(
                leading: Icon(Icons.child_care),
                title: Text('Dados da Criança'),
                onTap: () {
                  Navigator.pushNamed(context, '/dados_crianca');
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Sobre'),
                onTap: () {
                  Navigator.pushNamed(context, '/sobre');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buffet Completo'),
        backgroundColor: Colors.deepOrangeAccent, // Cor do AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar Fornecedores',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _filtrarFornecedores,
                ),
              ),
              onChanged: (value) {
                _filtrarFornecedores();
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _filtrarPor('domicilio');
                  },
                  child: Text('Domicílio'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _filtrarPor('promocoes');
                  },
                  child: Text('Promoções'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _filtrarPor('avaliacao');
                  },
                  child: Text('Avaliação'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredFornecedores.length,
                itemBuilder: (context, index) {
                  var fornecedor = _filteredFornecedores[index];
                  return ListTile(
                    title: Text(fornecedor['nome']),
                    subtitle: Text(fornecedor['descricao']),
                    onTap: () {
                      // Adicione aqui a lógica para quando o fornecedor for selecionado
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/bem_vindo');
              },
            ),
            IconButton(
              icon: Icon(Icons.receipt),
              onPressed: () {
                Navigator.pushNamed(context, '/orcamento');
              },
            ),
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: _abrirMenu,
            ),
          ],
        ),
      ),
    );
  }
}
