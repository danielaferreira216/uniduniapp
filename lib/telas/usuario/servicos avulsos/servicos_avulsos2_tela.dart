import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicosAvulsos2Tela extends StatefulWidget {
  final String categoria;

  ServicosAvulsos2Tela({required this.categoria});

  @override
  _ServicosAvulsos2TelaState createState() => _ServicosAvulsos2TelaState();
}

class _ServicosAvulsos2TelaState extends State<ServicosAvulsos2Tela> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _fornecedores = [];
  List<DocumentSnapshot> _filteredFornecedores = [];
  bool _ordenacaoNomeCrescente = true;
  bool _ordenacaoPrecoCrescente = true;

  @override
  void initState() {
    super.initState();
    _carregarFornecedores();
  }

  void _carregarFornecedores() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('servicos_avulsos')
        .where('categoria', isEqualTo: widget.categoria)
        .get();
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

  void _ordenarPorNome() {
    setState(() {
      if (_ordenacaoNomeCrescente) {
        _filteredFornecedores.sort((a, b) {
          return a['nome'].toLowerCase().compareTo(b['nome'].toLowerCase());
        });
      } else {
        _filteredFornecedores.sort((a, b) {
          return b['nome'].toLowerCase().compareTo(a['nome'].toLowerCase());
        });
      }
      _ordenacaoNomeCrescente = !_ordenacaoNomeCrescente;
    });
  }

  void _ordenarPorPreco() {
    setState(() {
      if (_ordenacaoPrecoCrescente) {
        _filteredFornecedores.sort((a, b) {
          return (a['preco'] as num).compareTo(b['preco'] as num);
        });
      } else {
        _filteredFornecedores.sort((a, b) {
          return (b['preco'] as num).compareTo(a['preco'] as num);
        });
      }
      _ordenacaoPrecoCrescente = !_ordenacaoPrecoCrescente;
    });
  }

  void _ordenarPorAvaliacao() {
    setState(() {
      _filteredFornecedores.sort((a, b) {
        return (b['avaliacao'] as num).compareTo(a['avaliacao'] as num);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serviços de ${widget.categoria}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar Serviços',
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
                  onPressed: _ordenarPorNome,
                  child: Row(
                    children: [
                      Text('Nome'),
                      Icon(_ordenacaoNomeCrescente ? Icons.arrow_upward : Icons.arrow_downward),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _ordenarPorPreco,
                  child: Row(
                    children: [
                      Text('Preço'),
                      Icon(_ordenacaoPrecoCrescente ? Icons.arrow_upward : Icons.arrow_downward),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _ordenarPorAvaliacao,
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fornecedor['descricao']),
                        Text('Valor: R\$${fornecedor['preco']}'), // Adiciona o campo valor
                      ],
                    ),
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
              onPressed: () {
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
