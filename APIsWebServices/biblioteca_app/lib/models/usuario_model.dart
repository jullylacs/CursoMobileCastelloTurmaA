//classe de modelagem do usuário (atributos iguaos aos do BD )
class UsuarioModel {
  //atribyutos
  final String? id; //pode ser inicializado como nulo
  final String nome;
  final String email;

  //construtor
  UsuarioModel({this.id, required this.nome, required this.email});

  //fromjson Map => OBJ
  factory UsuarioModel.fromJson(Map<String, dynamic> json) =>
      UsuarioModel(
        id: json["id"].toString(), 
        nome: json["nome"].toString(),   
        email: json["email"].toString()
      );

      //toJson OBJ => Map
      Map<String,dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "email": email
      };

}
