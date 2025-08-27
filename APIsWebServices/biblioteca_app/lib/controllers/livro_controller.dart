// classe Controller para livros

import 'package:biblioteca_app/models/livro_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class LivroController {
  //métodos
  //Get livro
  Future<List<LivroModel>> fetchAll() async {
    final list = await ApiService.getList("livros");
    //retornar a lista de livros
    return list.map<LivroModel>((e) => LivroModel.fromJson(e)).toList();
  }

  //Get livro
  Future<LivroModel> fetchOne(String id) async {
    final user = await ApiService.getOne("livros", id);
    return LivroModel.fromJson(user);
  }

  //Post livro
  Future<LivroModel> create(LivroModel u) async {
    final created = await ApiService.post("livros", u.toJson());
    return LivroModel.fromJson(created);
  }

  //Put livro
  Future<LivroModel> update(LivroModel u) async {
    final  updated = await ApiService.put("livros",u.toJson(), u.id!);
    return LivroModel.fromJson(updated);
  }

  //Delete livro
  Future<void> delete(String id) async {
    await ApiService.delete("livros", id); //não tem retorno
  }
}
