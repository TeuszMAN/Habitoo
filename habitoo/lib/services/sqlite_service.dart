import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:habitoo/models/resposta_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'storage_service.dart';

class SQLiteService implements StorageService {
  // Constantes para evitar "magic strings"
  static const _databaseName = 'q8rn.db';
  static const _databaseVersion = 1;
  static const _tableName = 'respostas';

  // Singleton pattern
  static final SQLiteService _instance = SQLiteService._internal();
  factory SQLiteService() => _instance;
  SQLiteService._internal();

  Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Adicionado para futuras atualizações
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        dataResposta TEXT NOT NULL,
        respostas TEXT NOT NULL,
        escoreTotal INTEGER NOT NULL,
        classificacao TEXT NOT NULL,
        escoresPorDominio TEXT NOT NULL,
        userId TEXT
      )
    ''');

    // Índice para melhor performance em buscas por usuário
    await db.execute('''
      CREATE INDEX idx_user_id ON $_tableName (userId)
    ''');
  }

  // Para futuras migrações de schema
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $_tableName ADD COLUMN userId TEXT');
    }
  }

  @override
  Future<void> salvarResposta(RespostaQ8RN resposta) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.insert(
        _tableName,
        _toMap(resposta),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  // Método auxiliar para conversão
  Map<String, dynamic> _toMap(RespostaQ8RN resposta) {
    return {
      'id': resposta.id,
      'dataResposta': resposta.dataResposta.toIso8601String(),
      'respostas': json.encode(resposta.resposta),
      'escoreTotal': resposta.escoreTotal,
      'classificacao': resposta.classificacao,
      'escoresPorDominio': json.encode(resposta.escoresPorDominio),
      'userId': resposta.userId,
    };
  }

  @override
  Future<List<RespostaQ8RN>> carregarHistorico({String? userId}) async {
    final db = await database;

    final where = userId != null ? 'userId = ?' : null;
    final whereArgs = userId != null ? [userId] : null;

    final maps = await db.query(
      _tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'dataResposta DESC',
    );

    return maps.map(_fromMap).toList();
  }

  // Método auxiliar para conversão
  RespostaQ8RN _fromMap(Map<String, dynamic> map) {
    return RespostaQ8RN.fromMap({
      'id': map['id'],
      'dataResposta': map['dataResposta'],
      'respostas': json.decode(map['respostas']),
      'escoreTotal': map['escoreTotal'],
      'classificacao': map['classificacao'],
      'escoresPorDominio': json.decode(map['escoresPorDominio']),
      'userId': map['userId'], // Novo campo
    });
  }

  // Novo: Busca resposta por ID
  Future<RespostaQ8RN?> getRespostaById(String id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return maps.isNotEmpty ? _fromMap(maps.first) : null;
  }

  // Novo: Atualiza resposta existente
  Future<int> atualizarResposta(RespostaQ8RN resposta) async {
    final db = await database;
    return await db.update(
      _tableName,
      _toMap(resposta),
      where: 'id = ?',
      whereArgs: [resposta.id],
    );
  }

  // Novo: Remove resposta
  Future<int> deletarResposta(String id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> exportDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final src = File(join(dbPath, _databaseName));

      if (!await src.exists()) {
        debugPrint('Arquivo do banco de dados não encontrado');
        return;
      }

      final destDir = await _getDownloadDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final dest = File(join(destDir.path, 'q8rn_$timestamp.db'));

      await src.copy(dest.path);
      debugPrint('Banco exportado para: ${dest.path}');
    } catch (e) {
      debugPrint('Erro ao exportar banco: $e');
      rethrow;
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    try {
      final dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    } catch (e) {
      // Fallback para diretório de documentos
      return Directory(await getDatabasesPath());
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
