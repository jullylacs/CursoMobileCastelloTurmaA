import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; //Importa a biblioteca SharedPreferences

class TelaInicial extends StatefulWidget {
  //Tela Dinâmica (mudança de estado)
  @override
  _TelaInicialState createState() => _TelaInicialState(); //Chama da Mudança de Estado
}

class _TelaInicialState extends State<TelaInicial> {
  //Estado da Tela Inicial
  //atributos
  TextEditingController _nomeController = TextEditingController(); //Recebe informações TextField
  String _nome = ""; // Atributo que Armazena o Nome do Usuário
  bool _darkMode = false; //Atributo que armazena o modo escuro

  // método InitState ->
  @override
  void initState() {
    //método para iniciar a tela
    super.initState();
    _carregarPreferencias();
  }

  //método para Carregar Nome do Usuário
  void _carregarPreferencias() async {
    //método assincrono
    SharedPreferences _prefs = await SharedPreferences.getInstance(); //pegar as informações do cache
    _nome = _prefs.getString("nome") ?? ""; //pega o nome do usuário no shared_
    _darkMode = _prefs.getBool("darkMode") ?? false; //pega o modo escuro shared_
    setState(() {
      // recarregar a tela
    });
  }

  //Método para Salvar o Nome do Usuário
  void _salvarNome() async {
    //adicinar o salar no shared preferences
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _nome = _nomeController.text.trim();
    if (_nome.isEmpty) {
      //Madar uma Mensagem para o usuário
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Informe um Nome Válido!")));
    } else {
      _nomeController.clear(); //limpa o TextField
      _prefs.setString("nome", _nome); //salva o nome no sharedPref
      setState(() {
        //Atualizar o Nome do usuário na Tela
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Nome do Usuário Atualizado!")));
      });
    }
  }

  //método salvar Modo Escuro
  void _salvarModoEscuro() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _darkMode = !_darkMode; //inverte o valor do darkmode(atributo)
    _prefs.setBool("darkMode", _darkMode); //salvo no Shared
    setState(() {
      //atualiza a tela
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Modo Escuro ${_darkMode ? "Ativado" : "Desativado"}")));
    });
  }

  

  @override
  Widget build(BuildContext context) {
    // Constroi a Tela
    return AnimatedTheme(
      //musa o tema da tela
      data: _darkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        //estrutura básica da tela
        appBar: AppBar(
          title: Text("Bem-vindo ${_nome == "" ? "Visitante" : _nome}"),
          actions: [
            IconButton(onPressed:_salvarModoEscuro,
             icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Informe seu Nome"),
              ),
              ElevatedButton(
                onPressed: _salvarNome,
                child: Text("Salvar Nome do Usuário"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// o que é o SharedPreferences?
// é uma biblioteca de armazenamento de dados interna do aplicativo (cache do app)
//como ela funciona?
// armazena dados na condição de chave-valor(key-value)
// nome -> _nome
// tipos de dados armazenados no Shared preferences:
// String, int, double, bool, List<String>
//métodos dos shared preferences:
// getters and setters
