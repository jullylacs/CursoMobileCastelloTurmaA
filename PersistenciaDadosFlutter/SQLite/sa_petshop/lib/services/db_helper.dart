import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  static Database? _database; //objeto para criar as conexões

  //transformar essa classe em singleton
  //não permite instanciar outro obj enquanto um obj estiver ativo
  static final DbHelper _instance = DbHelper._internal();

  //construir o Singleton
  DbHelper._internal();
  factory DbHelper(){
    return _instance;
  }

  //conexões do Banco de dados
  Future<Database> get database async{
    if(_database!= null){
      return _database!; //se o banco ja estiver funcionando, retorna ele mesmo
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async{
    // pegar o local onde esta salvo o banco de dados (path)
    final _dbPath = await getDatabasesPath();
    final path = join(_dbPath,"petshop.db"); //caminho para o banco de dados

    return await openDatabase(path); //cenas para o próximo capítulo
  }

}