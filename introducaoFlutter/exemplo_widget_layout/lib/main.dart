import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    //routes - rotas de navegação +1 tela
  ));
}

//Janela para estudo de Layout (Colums,Rows,Stacks,Containers)
class MyApp extends StatelessWidget{
  //Sobrescrever o método build
  @override
  Widget build(BuildContext context){
    return Scaffold( //suporte da Janela (appbar, body, bottonNB, drawer)
      appBar: AppBar(title:Text("Exemplo de Layout")),
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.black,
                  height: 200,
                  width: 200,
                ),
                Container(
                  color: const Color.fromARGB(255, 71, 162, 226),
                  height: 150,
                  width: 150,
                ),
                Icon(Icons.person, size: 100)
              ],
            ), // Stack
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: const Color.fromARGB(255, 140, 189, 223),
                  height: 100,
                  width: 100,
                ),
                Container(
                  color: const Color.fromARGB(255, 124, 182, 223),
                  height: 100,
                  width: 100,),
                Container(
                  color: const Color.fromARGB(255, 103, 172, 221),
                  height: 100,
                  width: 100,)
              ],
            ),// Row
            Text("Obervações importantes")
          ]), // Column
      ),
    );
  }
}