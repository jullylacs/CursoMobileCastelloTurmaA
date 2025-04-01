import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

// criar a Janela Principal
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Lista inicial de imagens
  List<String> _imagens = [
    "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
    "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
    "https://images.unsplash.com/photo-1518837695005-2083093ee35b",
    "https://images.unsplash.com/photo-1501594907352-04cda38ebc29",
    "https://images.unsplash.com/photo-1519681393784-d120267933ba",
    "https://images.unsplash.com/photo-1531259683007-016a7b628fc3",
    "https://images.unsplash.com/photo-1506619216599-9d16d0903dfd",
    "https://images.unsplash.com/photo-1494172961521-33799ddd43a5",
    "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4",
  ];

  // Controlador de texto para capturar a URL da imagem
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Galeria de Imagens"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(height: 10), // Espaçamento entre o campo de texto e a galeria
            // Campo de texto para adicionar nova imagem
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Digite a URL da Imagem',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 10), // Espaçamento
            ElevatedButton(
              onPressed: _adicionarImagem,
              child: Text('Adicionar Imagem'),
            ),
            SizedBox(height: 10), // Espaçamento
            // Galeria de imagens em uma grade
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // quantidade de imagens por linha
                  crossAxisSpacing: 8, // espaçamento entre colunas
                  mainAxisSpacing: 8, // espaçamento entre linha
                ),
                itemCount: _imagens.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => _mostrarImagem(context, _imagens[index]), // Exibe a Imagem em tela cheia ao tocar
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(_imagens[index], fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para adicionar imagem
  void _adicionarImagem() {
    final String url = _urlController.text;

    if (url.isNotEmpty) {
      setState(() {
        _imagens.add(url); // Adiciona a URL da imagem à lista
      });
      _urlController.clear(); // Limpa o campo de texto após adicionar a imagem
    } else {
      // Exibe um alerta caso o campo esteja vazio
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('URL inválida'),
          content: Text('Por favor, insira uma URL de imagem válida.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar'),
            ),
          ],
        ),
      );
    }
  }

  // Função para mostrar a imagem em tela cheia
  void _mostrarImagem(BuildContext context, String imagem) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.network(imagem),
      ),
    );
  }
}
