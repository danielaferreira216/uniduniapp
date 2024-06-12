import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'telas/usuario/cadastro/registro_tela.dart';
import 'telas/pesquisa_tela.dart';
import 'telas/menu_inferior/orcamento_tela.dart';
import 'telas/usuario/login e tela inicial/login_tela.dart';
import 'telas/usuario/login e tela inicial/esqueceu_senha_tela.dart';
import 'telas/usuario/cadastro/complemento_cadastro_tela.dart';
import 'telas/usuario/login e tela inicial/bem_vindo_tela.dart';
import 'telas/usuario/servicos avulsos/servicos_avulsos_tela.dart';
import 'telas/usuario/servicos avulsos/servicos_avulsos2_tela.dart';
import 'telas/usuario/buffet completo/buffet_completo_tela.dart';
import 'telas/usuario/splash_tela.dart';
import 'telas/fornecedor/login_fornecedor_tela.dart';
import 'telas/fornecedor/bem_vindo_fornecedor_tela.dart';
import 'telas/fornecedor/adicionar_evento_tela.dart';
import 'telas/fornecedor/adicionar_fornecedor_tela.dart';
import 'telas/fornecedor/adicionar_orcamento_tela.dart';
import 'telas/fornecedor/adicionar_servico_avulso_tela.dart';
import 'telas/fornecedor/gerenciar_dados_tela.dart';
import 'telas/menu_inferior/sobre_tela.dart';
import 'telas/fornecedor/eventos_tela.dart'; 

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyAs4KSHhwVFtOBO67eVy0CvrnWrRf7NS40",
  authDomain: "uniduniapp-15768.firebaseapp.com",
  projectId: "uniduniapp-15768",
  storageBucket: "uniduniapp-15768.appspot.com",
  messagingSenderId: "110623889403",
  appId: "1:110623889403:web:3954f56fae0c2cfb521d5e",
  measurementId: "G-D65GVE0KK1",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uni Duni',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashTela(),
        '/login': (context) => LoginTela(),
        '/registro': (context) => RegistroTela(),
        '/pesquisa': (context) => PesquisaTela(),
        '/orcamento': (context) => OrcamentoTela(),
        '/esqueceu_senha': (context) => EsqueceuSenhaTela(),
        '/complemento_cadastro': (context) => ComplementoCadastroTela(),
        '/bem_vindo': (context) => BemVindoTela(),
        '/servicos_avulsos': (context) => ServicosAvulsosTela(),
        '/buffet_completo': (context) => BuffetCompletoTela(),
        '/login_fornecedor': (context) => LoginFornecedorTela(),
        '/bem_vindo_fornecedor': (context) => BemVindoFornecedorTela(),
        '/adicionar_evento': (context) => AdicionarEventoTela(),
        '/adicionar_fornecedor': (context) => AdicionarFornecedorTela(),
        '/adicionar_orcamento': (context) => AdicionarOrcamentoTela(),
        '/adicionar_servico_avulso': (context) => AdicionarServicoAvulsoTela(),
        '/gerenciar_dados': (context) => GerenciarDadosTela(),
        '/sobre': (context) => SobreTela(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/servicos_avulsos2') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return ServicosAvulsos2Tela(categoria: args['categoria']);
            },
          );
        }
        return null;
      },
    );
  }
}
