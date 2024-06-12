import 'package:flutter/material.dart';

class SobreTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o Projeto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tema Escolhido:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Aplicativo de Orçamento para Festas Infantis',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Objetivo do Aplicativo:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'O objetivo do aplicativo é conectar clientes em potencial com fornecedores de serviços para festas infantis, '
              'facilitando a organização de eventos como aniversários, festas escolares, e outros eventos sociais voltados para crianças.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Desenvolvedor:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Daniela Alves Ferreira Santa Maria',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
