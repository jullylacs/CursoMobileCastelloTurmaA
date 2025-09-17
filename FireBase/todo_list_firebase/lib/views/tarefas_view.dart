import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TarefasView extends StatefulWidget {
  const TarefasView({super.key});

  @override
  State<TarefasView> createState() => _TarefasViewState();
}

class _TarefasViewState extends State<TarefasView> {
  final _db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final _tarefasField = TextEditingController();

  void _addTarefa() async {
    if (_tarefasField.text.trim().isEmpty) return;
    try {
      await _db
          .collection("usuarios")
          .doc(_user!.uid)
          .collection("tarefas")
          .add({
        "titulo": _tarefasField.text.trim(),
        "concluida": false,
        "dataCriacao": Timestamp.now(),
      });
      _tarefasField.clear(); // limpa o campo após adicionar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao adicionar Tarefa: $e")),
      );
    }
  }

  void _updateTarefa(String tarefaID, bool statusTarefa) async {
    await _db
        .collection("usuarios")
        .doc(_user!.uid)
        .collection("tarefas")
        .doc(tarefaID)
        .update({"concluida": !statusTarefa});
  }

  void _deleteTarefa(String tarefaID) async {
    await _db
        .collection("usuarios")
        .doc(_user!.uid)
        .collection("tarefas")
        .doc(tarefaID)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text("Minhas Tarefas"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _tarefasField,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  labelText: "Adicionar nova tarefa",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: _addTarefa,
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db
                    .collection("usuarios")
                    .doc(_user?.uid)
                    .collection("tarefas")
                    .orderBy("dataCriacao", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhuma tarefa cadastrada ainda.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  final tarefas = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = tarefas[index];
                      final tarefaMap = tarefa.data() as Map<String, dynamic>;
                      final bool concluida = tarefaMap["concluida"] == true;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1.5,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            tarefaMap["titulo"],
                            style: TextStyle(
                              decoration: concluida
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: concluida
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                          leading: Checkbox(
                            shape: const CircleBorder(),
                            activeColor: Colors.green,
                            value: concluida,
                            onChanged: (value) {
                              _updateTarefa(tarefa.id, concluida);
                            },
                          ),
                          trailing: IconButton(
                            onPressed: () => _deleteTarefa(tarefa.id),
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
