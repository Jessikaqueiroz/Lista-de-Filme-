import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'filme.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'filmes.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE filmes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imageUrl TEXT,
            titulo TEXT,
            genero TEXT,
            faixaEtaria TEXT,
            duracao INTEGER,
            pontuacao REAL,
            descricao TEXT,
            ano INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<int> insertFilme(Filme filme) async {
    final db = await database;
    return await db.insert('filmes', filme.toMap());
  }

  Future<List<Filme>> fetchFilmes() async {
    final db = await database;
    final result = await db.query('filmes');
    return result.map((map) => Filme.fromMap(map)).toList();
  }

  Future<int> updateFilme(Filme filme) async {
    final db = await database;
    return await db.update('filmes', filme.toMap(),
        where: 'id = ?', whereArgs: [filme.id]);
  }

  Future<int> deleteFilme(int id) async {
    final db = await database;
    return await db.delete('filmes', where: 'id = ?', whereArgs: [id]);
  }
}
