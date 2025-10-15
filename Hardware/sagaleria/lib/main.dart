import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ImageScreen(),
  ));
}

/// Modelo: imagem + localização + data/hora
class ImagemComLocalizacao {
  final File imagem;
  final String local;
  final DateTime dataHora;

  ImagemComLocalizacao({
    required this.imagem,
    required this.local,
    required this.dataHora,
  });
}

/// Tela principal
class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final ImagePicker _picker = ImagePicker();
  List<ImagemComLocalizacao> _imagensComLocal = [];

  // Obter localização atual como string
  Future<String> _getCurrentLocationString() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return "Serviço de localização desativado";

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return "Permissão negada";
    }

    if (permission == LocationPermission.deniedForever) {
      return "Permissão negada permanentemente";
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks[0];
      return "${place.locality}, ${place.administrativeArea} "
          "(${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})";
    }

    return "Localização desconhecida";
  }

  // Tirar foto com a câmera
  Future<void> _getImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final local = await _getCurrentLocationString();
      final agora = DateTime.now();

      setState(() {
        _imagensComLocal.add(
          ImagemComLocalizacao(
            imagem: File(pickedFile.path),
            local: local,
            dataHora: agora,
          ),
        );
      });
    }
  }

  // Selecionar várias imagens da galeria
  Future<void> _getImageFromGallery() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      final local = await _getCurrentLocationString();
      final agora = DateTime.now();

      setState(() {
        _imagensComLocal.addAll(pickedFiles.map((file) =>
            ImagemComLocalizacao(
              imagem: File(file.path),
              local: local,
              dataHora: agora,
            )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selecionar Imagens e Localização")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _getImageFromCamera, child: Text("Tirar Foto")),
                ElevatedButton(
                    onPressed: _getImageFromGallery,
                    child: Text("Escolher da Galeria")),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: _imagensComLocal.isEmpty
                  ? Center(child: Text("Nenhuma imagem selecionada."))
                  : GridView.builder(
                      itemCount: _imagensComLocal.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetalheImagemScreen(
                                  imagemComLocal: _imagensComLocal[index],
                                ),
                              ),
                            );
                          },
                          child: Image.file(
                            _imagensComLocal[index].imagem,
                            fit: BoxFit.cover,
                          ),
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

/// Tela de detalhes da imagem
class DetalheImagemScreen extends StatelessWidget {
  final ImagemComLocalizacao imagemComLocal;

  const DetalheImagemScreen({super.key, required this.imagemComLocal});

  @override
  Widget build(BuildContext context) {
    final dataFormatada = "${imagemComLocal.dataHora.day.toString().padLeft(2, '0')}/"
        "${imagemComLocal.dataHora.month.toString().padLeft(2, '0')}/"
        "${imagemComLocal.dataHora.year} "
        "${imagemComLocal.dataHora.hour.toString().padLeft(2, '0')}:"
        "${imagemComLocal.dataHora.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: Text("Detalhes da Imagem")),
      body: Column(
        children: [
          Expanded(
            child: Image.file(imagemComLocal.imagem, fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "📍 Local: ${imagemComLocal.local}",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "🕒 Data e Hora: $dataFormatada",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
