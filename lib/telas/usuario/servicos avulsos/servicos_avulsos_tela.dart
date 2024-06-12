import 'package:flutter/material.dart';
import '../../menu_inferior/sobre_tela.dart'; // Certifique-se de que esta linha está presente

class ServicosAvulsosTela extends StatelessWidget {
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
      appBar: AppBar(
        title: Text('Serviços Avulsos'),
              ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildButton(context, 'Pintura Facial'),
            _buildButton(context, 'Palhaço'),
            _buildButton(context, 'Recreação'),
            _buildButton(context, 'Decoração'),
            _buildButton(context, 'Brinquedos'),
            _buildButton(context, 'Personagens'),
            _buildButton(context, 'Arco de Balões'),
            _buildButton(context, 'Pegue e Monte'),
            _buildButton(context, 'Barraquinhas'),
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
              onPressed: () => _abrirMenu(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/servicos_avulsos2',
          arguments: {'categoria': label},
        );
      },
      child: Text(label, style: TextStyle(color: Colors.black, fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 253, 190, 171),
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Cantos arredondados
        ),
      ),
    );
  }
}
