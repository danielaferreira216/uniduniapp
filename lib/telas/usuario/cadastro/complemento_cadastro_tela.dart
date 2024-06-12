import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // Adiciona essa importação para formatação de datas

class ComplementoCadastroTela extends StatefulWidget {
  @override
  _ComplementoCadastroTelaState createState() => _ComplementoCadastroTelaState();
}

class _ComplementoCadastroTelaState extends State<ComplementoCadastroTela> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _nomeFilhosControllers = [];
  final List<DateTime?> _dataNascimentoFilhos = [];

  @override
  void initState() {
    super.initState();
    _addFilhoField();
  }

  void _addFilhoField() {
    setState(() {
      _nomeFilhosControllers.add(TextEditingController());
      _dataNascimentoFilhos.add(null);
    });
  }

  void _prosseguir() async {
    if (_formKey.currentState!.validate()) {
      List<Map<String, String>> filhos = [];
      for (int i = 0; i < _nomeFilhosControllers.length; i++) {
        filhos.add({
          'nome': _nomeFilhosControllers[i].text,
          'dataNascimento': _dataNascimentoFilhos[i] != null
              ? DateFormat('dd/MM/yyyy').format(_dataNascimentoFilhos[i]!)
              : '',
        });
      }

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).update({
          'filhos': filhos,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cadastro complementar concluído!')));
        Navigator.pushNamed(context, '/bem_vindo');
      }
    }
  }

  Future<void> _selecionarData(int index) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dataNascimentoFilhos[index]) {
      setState(() {
        _dataNascimentoFilhos[index] = picked;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _nomeFilhosControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados da Criança'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, // Define o fundo branco
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50), // Espaço adicionado para balancear o layout
                  Text(
                    'Completar Cadastro',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Vamos cadastrar as informações do seu filho(a), tudo bem?',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ..._buildFilhosFields(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addFilhoField,
                    child: Text(
                      'Adicionar Mais Um Filho(a)',
                      style: TextStyle(color: Colors.black), 
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 253, 172, 147),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _prosseguir,
                    child: Text(
                      'Prosseguir',
                      style: TextStyle(color: Colors.black), 
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFilhosFields() {
    List<Widget> fields = [];
    for (int i = 0; i < _nomeFilhosControllers.length; i++) {
      fields.add(
        Column(
          children: [
            TextFormField(
              controller: _nomeFilhosControllers[i],
              decoration: InputDecoration(
                labelText: 'Nome da Criança',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.child_care),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome da criança';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selecionarData(i),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento da Criança',
                    hintText: 'dd/mm/aaaa',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: _dataNascimentoFilhos[i] != null
                        ? DateFormat('dd/MM/yyyy').format(_dataNascimentoFilhos[i]!)
                        : '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a data de nascimento da criança';
                    }
                    return null;
                  },
                  readOnly: true,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }
    return fields;
  }
}
