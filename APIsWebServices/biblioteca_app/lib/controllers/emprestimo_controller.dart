// classe Controller para emprestimo s

import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class EmprestimoController {
  //métodos
  //Get emprestimo
  Future<List<EmprestimoModel>> fetchAll() async {
    final list = await ApiService.getList("emprestimo");
    //retornar a lista de usuários
    return list.map<EmprestimoModel>((e) => EmprestimoModel.fromJson(e)).toList();
  }

  //Get emprestimo 
  Future<EmprestimoModel> fetchOne(String id) async {
    final user = await ApiService.getOne("emprestimo", id);
    return EmprestimoModel.fromJson(user);
  }

  //Post emprestimo 
  Future<EmprestimoModel> create(EmprestimoModel u) async {
    final created = await ApiService.post("emprestimo", u.toJson());
    return EmprestimoModel.fromJson(created);
  }

  //Put emprestimo 
  Future<EmprestimoModel> update(EmprestimoModel u) async {
    final  updated = await ApiService.put("emprestimo",u.toJson(), u.id!);
    return EmprestimoModel.fromJson(updated);
  }

  //Delete emprestimo 
  Future<void> delete(String id) async {
    await ApiService.delete("emprestimo", id); //não tem retorno
  }
}
