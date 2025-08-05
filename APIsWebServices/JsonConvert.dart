//Converter Json <-> Dart
import 'dart:convert'; //não instalar no pubspec/native

void main() {
  String jsonString = '''{
                        "id": "abc123",
                        "name": "Pedro",
                        "idade": 25, 
                        "ativo": true,     
                        "login": "UserPedro",
                        "password": "1234"               
                        }''';
  
  // Decode JsonString
  Map<String,dynamic> usuario = json.decode(jsonString);
  print(usuario["nome"]); //Pedro
  print(usuario["login"]); //UserPedro
  
 //modificar a senha para 6 digitos / salvar no JsonString
  usuario["password"] = "123456";

  //gravar mo Json
  jsonString = json.encode(usuario);
  
  print(jsonString);
 
}