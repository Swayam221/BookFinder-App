
import 'package:bookfinder_app/book_pagination.dart';
import 'package:bookfinder_app/screens/add_book.dart';
import 'package:bookfinder_app/services/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  var bookPagination ;
  var gridController = ScrollController();
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
    //bookPagination = Provider.of<BookPagination>(context);

  }

  Future<void> getBooks() async
  {
    books = await Services.getBooks();
    setState(() {
      
    });
  }

  @override
  void didChangeDependencies()
  {
    super.didChangeDependencies();
    print("didChangedependencies");
    this.bookPagination = Provider.of<BookPagination>(context);
    //bookPagination.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    //bookPagination.getBooks();
    gridController.addListener(() {
      if(gridController.position.pixels == gridController.position.maxScrollExtent)
        bookPagination.getBooks();
      }
    );
    getBooks();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child:GridView.builder(
              controller: gridController,
              primary: false,shrinkWrap: true,physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                // children: books.map((i) => BookCard(title: i.title,author: i.author,publishDate: i.datePublished)).toList(),
              ),
              itemCount: bookPagination.books.length,
              itemBuilder: (context,index) {
                return BookCard(title: bookPagination.books[index].title,author: bookPagination.books[index].author,publishDate: bookPagination.books[index].datePublished.toString().split(' ')[0]);
              },
            ),
          ),
          if(bookPagination.loading)
          CircularProgressIndicator(),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBookPage()));},
        tooltip: 'Add A book',
        child: Icon(Icons.add),
      ), 
    );
  }
}