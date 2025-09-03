import 'package:biblioteca_app/controllers/livro_controller.dart';
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:biblioteca_app/views/livro/livro_form_view.dart'; // Certifique-se de que esse arquivo retorna um Widget
import 'package:flutter/material.dart';

class LivroListView extends StatefulWidget {
  const LivroListView({super.key});

  @override
  State<LivroListView> createState() => _LivroListViewState();
}

class _LivroListViewState extends State<LivroListView> {
  final _controller = LivroController();
  List<LivroModel> _livros = [];
  List<LivroModel> _livrosFiltrados = [];
  final _buscaField = TextEditingController();
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      _livros = await _controller.fetchAll();
      _livrosFiltrados = List.from(_livros);
    } catch (e) {
      // TODO: Tratar erro com um SnackBar ou Dialog
    }
    setState(() => _carregando = false);
  }

  Future<void> _delete(LivroModel livro) async {
    if (livro.id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja realmente excluir o livro \"${livro.titulo}\"?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancelar")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Confirmar")),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _controller.delete(livro.id!);
        await _carregarDados();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Livro excluído com sucesso")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao excluir o livro")),
        );
      }
    }
  }

  Future<void> _abrirForm({LivroModel? livro}) async {
    final atualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivroFormView(livro: livro),
      ),
    );

    if (atualizado == true) {
      await _carregarDados(); // Recarrega lista após edição/criação
    }
  }

  void _filtrar() {
    final busca = _buscaField.text.toLowerCase();
    setState(() {
      _livrosFiltrados = _livros.where((livro) {
        final titulo = livro.titulo.toLowerCase();
        final autor = livro.autor.toLowerCase();
        return titulo.contains(busca) || autor.contains(busca);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Livros")),
      body: _carregando
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _buscaField,
                    decoration: InputDecoration(
                      labelText: "Pesquisar Livro",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (_) => _filtrar(),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: _livrosFiltrados.isEmpty
                        ? Center(child: Text("Nenhum livro encontrado."))
                        : ListView.builder(
                            itemCount: _livrosFiltrados.length,
                            itemBuilder: (context, index) {
                              final livro = _livrosFiltrados[index];
                              return Card(
                                child: ListTile(
                                  leading: Icon(Icons.book),
                                  title: Text(livro.titulo),
                                  subtitle: Text("Autor: ${livro.autor}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _abrirForm(livro: livro),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _delete(livro),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
