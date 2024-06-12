import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventosTela extends StatelessWidget {
  Future<List<DocumentSnapshot>> _fetchEventos() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('eventos').get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchEventos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar eventos'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum evento encontrado'));
          }

          var eventos = snapshot.data!;
          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              var evento = eventos[index];
              return ListTile(
                title: Text(evento['titulo']),
                subtitle: Text(evento['descricao']),
                onTap: () {
                  // Lógica adicional ao clicar em um evento
                },
              );
            },
          );
        },
      ),
    );
  }
}
