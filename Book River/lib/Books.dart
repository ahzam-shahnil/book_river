import 'package:flutter/material.dart';

class Book {
  int bookid;
  String bookTitle;
  int bookPrice;
  String bookAuthor;

  Book(
      {@required this.bookTitle,
      @required this.bookPrice,
      @required this.bookAuthor,
      this.bookid});

  Map<String, dynamic> toMap() {
    return {
      'bookTitle': bookTitle,
      'bookPrice': bookPrice,
      'bookAuthor': bookAuthor,
    
    };
  }
}
