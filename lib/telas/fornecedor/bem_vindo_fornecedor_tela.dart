import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adicionar_evento_tela.dart';
import 'adicionar_fornecedor_tela.dart';
import 'adicionar_orcamento_tela.dart';
import 'adicionar_servico_avulso_tela.dart';

class BemVindoFornecedorTela extends StatelessWidget {
  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('fornecedores').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>;
        } else {
          print("Documento não encontrado");
          return {};
        }
      } catch (e) {
        print("Erro ao buscar dados do Firestore: $e");
        return {};
      }
    } else {
      print("Usuário não está autenticado");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum dado encontrado'));
          }

          var userData = snapshot.data!;
          var nome = userData['nome'];

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo, $nome!',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildButton(context, 'Eventos', Icons.event, const Color.fromARGB(255, 135, 196, 247)),
                      _buildButton(context, 'Indicações', Icons.business, const Color.fromARGB(255, 146, 243, 149)),
                      _buildButton(context, 'Orçamentos', Icons.receipt, const Color.fromARGB(255, 247, 208, 149)),
                      _buildButton(context, 'Serviços', Icons.miscellaneous_services, const Color.fromARGB(255, 232, 167, 243)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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

  Widget _buildButton(BuildContext context, String label, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () {
        switch (label) {
          case 'Eventos':
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarEventoTela()));
            break;
          case 'Indicações':
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarFornecedorTela()));
            break;
          case 'Orçamentos':
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarOrcamentoTela()));
            break;
          case 'Serviços':
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarServicoAvulsoTela()));
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50),
          SizedBox(height: 10),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
