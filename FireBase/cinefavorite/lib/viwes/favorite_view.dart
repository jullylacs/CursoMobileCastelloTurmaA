import 'package:cinefavorite/controllers/movie_firestore_controller.dart';
import 'package:cinefavorite/models/movie.dart';
import 'package:cinefavorite/viwes/search_movie_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final _movieController = MovieFirestoreController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Filmes Favoritos"),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder<List<Movie>>(
        stream: _movieController.getFavoriteMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao Carregar a Lista de Favoritos"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhum Filme Adicionado aos Favoritos"),
            );
          }

          final favoriteMovies = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 40),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Nota: ${movie.rating}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                tooltip: "Editar avaliação",
                                onPressed: () => _showEditRatingDialog(movie),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                tooltip: "Remover dos favoritos",
                                onPressed: () => _deleteMovie(movie),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchMovieView()),
        ),
        child: const Icon(Icons.search),
      ),
    );
  }

  void _showEditRatingDialog(Movie movie) {
    final _ratingController = TextEditingController(text: movie.rating?.toString() ?? "0");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Avaliação"),
          content: TextField(
            controller: _ratingController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Nota (1 a 10)",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                final newRating = double.tryParse(_ratingController.text);
                if (newRating != null && newRating >= 1 && newRating <= 10) {
                  _movieController.updateMovieRating(movie.id, newRating);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Informe uma nota válida entre 1 e 10")),
                  );
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _deleteMovie(Movie movie) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remover Filme"),
        content: Text('Deseja remover "${movie.title}" dos favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Remover", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _movieController.deleteFavoriteMovie(movie.id);
    }
  }
}
