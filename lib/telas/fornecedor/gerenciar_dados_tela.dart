import 'package:flutter/material.dart';
import 'adicionar_evento_tela.dart';
import 'adicionar_fornecedor_tela.dart';
import 'adicionar_orcamento_tela.dart';
import 'adicionar_servico_avulso_tela.dart';

class GerenciarDadosTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Dados'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Adicionar Evento'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdicionarEventoTela()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Adicionar Fornecedor'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdicionarFornecedorTela()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Adicionar Orçamento'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdicionarOrcamentoTela()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.miscellaneous_services),
            title: Text('Adicionar Serviço Avulso'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdicionarServicoAvulsoTela()),
              );
            },
          ),
        ],
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
                Navigator.pushNamed(context, '/bem_vindo_fornecedor');
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
