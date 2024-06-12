import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrcamentoTela extends StatefulWidget {
  @override
  _OrcamentoTelaState createState() => _OrcamentoTelaState();
}

class _OrcamentoTelaState extends State<OrcamentoTela> {
  List<DocumentSnapshot> _servicos = [];
  Map<String, bool> _selecionados = {};

  @override
  void initState() {
    super.initState();
    _carregarServicos();
  }

  void _carregarServicos() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('servicos').get();
    setState(() {
      _servicos = querySnapshot.docs;
      _selecionados = Map.fromIterable(
        _servicos,
        key: (servico) => servico.id,
        value: (servico) => false,
      );
    });
  }

  double _calcularOrcamento() {
    double total = 0.0;
    _selecionados.forEach((id, selecionado) {
      if (selecionado) {
        var servico = _servicos.firstWhere((servico) => servico.id == id);
        total += servico['preco'];
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orçamento em Tempo Real'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _servicos.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _servicos.length,
                      itemBuilder: (context, index) {
                        var servico = _servicos[index];
                        return CheckboxListTile(
                          title: Text(servico['nome']),
                          subtitle: Text('R\$ ${servico['preco'].toStringAsFixed(2)}'),
                          value: _selecionados[servico.id],
                          onChanged: (bool? value) {
                            setState(() {
                              _selecionados[servico.id] = value!;
                            });
                          },
                        );
                      },
                    ),
            ),
            SizedBox(height: 20),
            Text(
              'Total: R\$ ${_calcularOrcamento().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
