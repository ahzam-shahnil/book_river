import 'dart:ui';
import 'package:flutter/material.dart';
import 'Books.dart';
import 'DBHelper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper dbHelper = new DBHelper();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  bool searchCheck = false;
  int searchId;

  Book book;

  List<Book> bookList;
  int updateIndex;

  void initState() {
    super.initState();
    // refreshList();
  }

  refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final ThemeData mode = Theme.of(context);
    var whichMode = mode.brightness;
    return Scaffold(
      appBar: AppBar(
        title: Text('Book River'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                //0 represents insert or add here
                setState(() {
                  searchCheck = false;
                });
                refreshList();
              },
              child: Icon(
                Icons.home_outlined,
                size: 27.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                //0 represents insert or add here
                openDialogueBox(context, 0, book);
              },
              child: Icon(
                Icons.add,
                size: 27.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                searchDialogueBox(context);
              },
              child: Icon(
                Icons.search_outlined,
                size: 27.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: searchCheck
            ? dbHelper.searchBookList(searchId)
            : dbHelper.getBookList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bookList = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: bookList == null ? 0 : bookList.length,
              itemBuilder: (BuildContext context, int index) {
                Book book = bookList[index];
                return Card(
                  color: whichMode == Brightness.dark
                      ? Colors.black12
                      : Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: width * 0.65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Book ID : ${book.bookid}',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Title: ${book.bookTitle}',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Price : ${book.bookPrice}',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Author : ${book.bookAuthor}',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //1 represnts update button here
                            setState(() {
                              book = book;
                              updateIndex = index;
                              openDialogueBox(context, 1, book);
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            dbHelper.deleteBook(book.bookid);
                            setState(() {
                              bookList.removeAt(index);
                            });
                          },
                          icon:
                              Icon(Icons.delete_sweep, color: Colors.redAccent),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  searchDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Search Book'),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: 'Book ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  searchId = int.parse(_idController.text);
                  dbHelper.searchBookList(searchId).then((value) => {
                        _titleController.clear(),
                        _priceController.clear(),
                        _authorController.clear(),
                      });
                  searchCheck = true;
                  refreshList();
                  Navigator.pop(context);
                },
                child: Text('Search'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  openDialogueBox(BuildContext context, int num, Book books) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: num == 0
                ? Text('Add Book Details')
                : Text('Update Book Details'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if (num == 0) {
                    submitAction(context);
                  } else {
                    updateAction(context, books);
                  }
                  refreshList();
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
            content: num == 0
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: _authorController,
                          decoration: InputDecoration(
                            labelText: 'Author',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: _titleController
                            ..text = '${books.bookTitle}',
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: _priceController
                            ..text = '${books.bookPrice}',
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: _authorController
                            ..text = '${books.bookAuthor}',
                          decoration: InputDecoration(
                            labelText: 'Author',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  submitAction(BuildContext context) {
    if (book == null) {
      Book st = new Book(
        bookAuthor: _authorController.text,
        bookTitle: _titleController.text,
        bookPrice: int.parse(_priceController.text),
      );
      dbHelper.insertBook(st).then((value) => {
            _titleController.clear(),
            _priceController.clear(),
            _authorController.clear(),
          });
    }
  }

  updateAction(BuildContext context, Book book) {
    book.bookTitle = _titleController.text;
    book.bookPrice = int.parse(_priceController.text);
    book.bookAuthor = _authorController.text;

    dbHelper.updateBook(book).then((value) => {
          _titleController.clear(),
          _priceController.clear(),
          _authorController.clear(),
          setState(() {
            bookList[updateIndex].bookTitle = _titleController.text;
            bookList[updateIndex].bookPrice = int.parse(_priceController.text);
            bookList[updateIndex].bookAuthor = _authorController.text;
          }),
          book = null
        });
  }
}
