import 'package:flutter/material.dart';
import 'usuario/servicos avulsos/servicos_avulsos_tela.dart';
import 'usuario/buffet completo/buffet_completo_tela.dart';

class ServicosTela extends StatelessWidget {
  final String tipo;

  ServicosTela({required this.tipo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Serviços de $tipo'),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButton(context, 'Serviços Avulsos', ServicosAvulsosTela()),
            SizedBox(height: 20),
            _buildButton(context, 'Buffet Completo', BuffetCompletoTela()),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Fechar'),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String label, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
      },
      child: Text(label, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),  // Cantos arredondados
        ),
      ),
    );
  }
}
