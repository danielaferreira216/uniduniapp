import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../servicos_tela.dart';
import 'package:projeto_p2/telas/menu_inferior/sobre_tela.dart';
import 'package:projeto_p2/telas/fornecedor/eventos_tela.dart';  

class BemVindoTela extends StatelessWidget {
  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
      return userDoc.data() as Map<String, dynamic>;
    }
    return {};
  }

  void _abrirMenu(BuildContext context) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SobreTela()),
                  );
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Nenhum dado encontrado'));
          }

          var userData = snapshot.data!;
          var nome = userData['nome'].split(' ')[0];
          var filhos = userData['filhos'] as List<dynamic>;

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
                Row(
                  children: filhos.map<Widget>((filho) {
                    return Container(
                      margin: EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        radius: 40,
                        child: Text(
                          filho['nome'].split(' ')[0],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildButton(context, 'Aniversário', const Color.fromARGB(255, 175, 245, 211)),
                            _buildButton(context, 'Evento', const Color.fromARGB(255, 158, 192, 250)),
                            _buildButton(context, 'Empresa', const Color.fromARGB(255, 252, 235, 175)),
                            _buildButton(context, 'Escola', const Color.fromARGB(255, 248, 176, 155)),
                          ],
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EventosTela()),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 200, 
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage('assets/banner.png'), 
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
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
              onPressed: () => _abrirMenu(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ServicosTela(tipo: label);
          },
        );
      },
      child: Text(label, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,  // Cor do botão
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),  // Cantos arredondados
        ),
      ),
    );
  }
}
