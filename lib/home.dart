
import 'package:bookfinder_app/screens/add_book.dart';
import 'package:bookfinder_app/services/api_calls.dart';
import 'package:flutter/material.dart';

import 'Widgets/book_card.dart';
import 'models/Book.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  List<Book> books = [];
  void _incrementCounter() {
    //Services.search('maze');
    //Services.addBook("Murder On The Orient Express", "Agatha Christie", "1934-01-01");
    setState(() {
      _counter++;
    });
  }
  @override
  void initState()
  {
    super.initState();
  }

  Future<void> getBooks() async
  {
    books = await Services.getBooks();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    getBooks();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: books.map((i) => BookCard(title: i.title,author: i.author,publishDate: i.datePublished)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBookPage()));},
        tooltip: 'Add A book',
        child: Icon(Icons.add),
      ), 
    );
  }
}