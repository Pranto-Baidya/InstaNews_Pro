
import 'dart:io';

import 'package:instanews_pro/news_models/db_bookmark_model/bookmark_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBService{

  static Database? db;

  static Future<Database> getDB()async{
    if(db!=null){
      return db!;
    }
    db = await initDB();
    return db!;
  }

  static Future<Database> initDB()async{
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = join(appDir.path,'BookMarkDB.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: createTable
    );
  }

  static Future<void> createTable(Database db, int version)async{
    await db.execute(
      '''
      CREATE TABLE bookmark(
       id TEXT PRIMARY KEY,
       title TEXT,
       description TEXT,
       imageUrl TEXT,
       categories TEXT,
       countries TEXT,
       newsUrl TEXT,
       newsSource TEXT,
       sourceIcon TEXT,
       dateTime TEXT
      )
      '''
    );
  }

  static Future<void> insertNews(BookmarkModel news)async{
    final db = await getDB();
    await db.insert('bookmark', news.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<BookmarkModel>> getAllNews()async{
    final db = await getDB();
    List<Map<String,dynamic>> value = await db.query('bookmark');
    return value.map((i)=>BookmarkModel.fromDbMap(i)).toList();
  }

  static Future<void> removeFromBookmark(String id)async{
    final db = await getDB();
    await db.delete('bookmark',where: 'id=?',whereArgs: [id]);
  }

  static Future<bool> hasBookmark(String id)async{
    final db = await getDB();
    List<Map<String,dynamic>> value = await db.query('bookmark',where : 'id=?', whereArgs: [id],limit: 1);
    return value.isNotEmpty;
  }
}
