import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF86AAE9),
        title: const Text(
          'Perfil de Usuário',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Foto de perfil com sombra e borda circular
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(106, 134, 170, 233),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage('assets/profile.jpg'), // Caminho para a foto no diretório assets
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Julia', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text(
              'Desenvolvedora | Apaixonada por tecnologia',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoCard(label: 'Idade: 18'),
                _InfoCard(label: 'Cidade: Limeira SP'),
                _InfoCard(label: 'Hobbies: Desenhar'),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: const [
                  _ListTile(icon: Icons.work, title: 'Desenvolvedora'),
                  _ListTile(icon: Icons.location_on, title: 'Limeira SP'),
                  _ListTile(icon: Icons.email, title: 'julialacerdasil@email.com'),
                  _ListTile(icon: Icons.phone, title: '(19) 989803660'),
                  _ListTile(icon: Icons.language, title: 'www.julias.com'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF86AAE9),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;

  const _InfoCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF86AAE9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ListTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF86AAE9)),
      title: Text(title, style: const TextStyle(color: Colors.black)),
    );
  }
}
