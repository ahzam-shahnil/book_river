import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Books.dart';

class DBHelper {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), 'book.db'),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Book(bookid INTEGER PRIMARY KEY autoincrement, bookTitle TEXT, bookAuthor TEXT , bookPrice INTEGER)',
        );
      });
    }
  }

  Future<int> insertBook(Book book) async {
    await openDb();
    return await _database.insert('Book', book.toMap());
  }

  Future<List<Book>> getBookList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('Book');
    return List.generate(maps.length, (i) {
      return Book(
        bookid: maps[i]['bookid'],
        bookTitle: maps[i]['bookTitle'],
        bookPrice: maps[i]['bookPrice'],
        bookAuthor: maps[i]['bookAuthor'],
      );
    });
  }

  Future<List<Book>> searchBookList(int id) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database
        .query('Book', where: "bookid LIKE '%?%'", whereArgs: [id]);
    return List.generate(maps.length, (i) {
      return Book(
        bookid: maps[i]['bookid'],
        bookTitle: maps[i]['bookTitle'],
        bookPrice: maps[i]['bookPrice'],
        bookAuthor: maps[i]['bookAuthor'],
      );
    });
  }

  Future<void> updateBook(Book book) async {
    try {
      await openDb();
      return await _database.update('Book', book.toMap(),
          where: "bookid = ?", whereArgs: [book.bookid]);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteBook(int id) async {
    try {
      await openDb();
      await _database.delete('Book', where: "bookid = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
    }
  }
}
