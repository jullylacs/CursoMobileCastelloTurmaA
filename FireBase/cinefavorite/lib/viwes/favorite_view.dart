import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  // Lista de filmes favoritos fictícios
  final List<Map<String, String>> favoriteMovies = const [
    {
      "title": "Interestelar",
      "description": "Uma jornada no tempo e espaço para salvar a humanidade.",
      "poster": "https://image.tmdb.org/t/p/w500/nCbkOyOMTePnuUBboZFo1Zy5fJv.jpg"
    },
    {
      "title": "O Poderoso Chefão",
      "description": "A história da máfia italiana nos EUA.",
      "poster": "https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg"
    },
    {
      "title": "Homem-Aranha: Sem Volta Para Casa",
      "description": "Três gerações de aranhas em um só filme.",
      "poster": "https://image.tmdb.org/t/p/w500/uJYYizSuA9Y3DCs0qS4qWvHfZg4.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Filmes Favoritos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Sair",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = favoriteMovies[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: Image.network(
                movie["poster"]!,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(movie["title"]!),
              subtitle: Text(movie["description"]!),
            ),
          );
        },
      ),
    );
  }
}
