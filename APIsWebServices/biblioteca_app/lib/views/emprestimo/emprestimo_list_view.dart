import 'package:biblioteca_app/controllers/emprestimo_controller.dart';
import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:flutter/material.dart';

class EmprestimoListView extends StatefulWidget {
  const EmprestimoListView({super.key});

  @override
  State<EmprestimoListView> createState() => _EmprestimoListViewState();
}

class _EmprestimoListViewState extends State<EmprestimoListView> {
  //atributos
  List<EmprestimoModel> emprestimo = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  _carregarDados() async{
    setState(() {
      _carregando = true;
    });
    try {
      emprestimo = await _controller.fetchAll();
    } catch (e) {
      //Tratar Erro      
    }
    setState(() {
      _carregando = false;
    });
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
      ? Center(child: CircularProgressIndicator(),)
      : Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: emprestimo.length,
          itemBuilder: (context,index){
            final emprestimo = emprestimo[index];
            return Card(
              child: ListTile(
                title: Text(emprestimo.dataEmprestimo.dataDevolucao),
                subtitle: Text(emprestimo.usuarioId),
                //trailing -> icone para deletar o usuário
              ),
            );
          }))
    );
  }
}
