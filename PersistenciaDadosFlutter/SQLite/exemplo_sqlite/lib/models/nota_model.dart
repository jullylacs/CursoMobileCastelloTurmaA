//criar a classe model para notas

class Nota{
  //atributos
  final int? id; //permite criar objeto com id nulo
  final String titulo;
  final String conteudo;

  //construtores
  Nota({this.id, required this.titulo, required this.conteudo}); //construtor com os atributos, required = obrigatório

  //métodos
  //converter dados para o banco de dados
  //método MAP => converte um objeto da classe para um MAP (para inserir no banco de dados)
  //MAP - lista onde a ordem é dada por uma chave associada a um valor
  Map<String,dynamic>toMAp(){
    return {
      "id" : id,
      "titulo" : titulo,
      "conteudo" : conteudo
    };
  }
}