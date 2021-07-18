
import 'package:bookfinder_app/book_pagination.dart';
import 'package:bookfinder_app/screens/add_book.dart';
import 'package:bookfinder_app/services/api_calls.dart';
import 'package:flutter/foundation.dart';
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
  var searchController = TextEditingController();
  List<Book> searchResults = [];
  var searching = false;
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
    gridController.addListener(() {
      if(gridController.position.pixels == gridController.position.maxScrollExtent)
        bookPagination.getBooks();
      }
    );
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
    
    getBooks();
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white.withOpacity(0.8),
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (val) async
            {
              print(searchController.text);
              if(searchController.text.isNotEmpty)
              {
                setState(() {
                  searching=true;
                });
                List<Book> sR = await Services.search(searchController.text);
                setState(() {
                  searchResults = sR;
                });
              }
              else {
                setState(() {
                  searching = false;  
                });
                
              }
            },
          ),
        ),
      ),
      body: !searching? Column(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child:GridView.builder(
              controller: gridController,
              primary: false,physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: !kIsWeb?2:4,mainAxisExtent: 400,
                // children: books.map((i) => BookCard(title: i.title,author: i.author,publishDate: i.datePublished)).toList(),
              ),
              itemCount: bookPagination.books.length,
              itemBuilder: (context,index) {
                return BookCard(title: bookPagination.books[index].title,author: bookPagination.books[index].author,publishDate: bookPagination.books[index].datePublished.toString().split(' ')[0],image: bookPagination.books[index].imageId);
              },
            ),
          ),
          if(bookPagination.loading)
          CircularProgressIndicator(),
        ]
      ):searchResults.isNotEmpty?Column(
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
                crossAxisCount: !kIsWeb?2:4,mainAxisExtent: 400,
                // children: books.map((i) => BookCard(title: i.title,author: i.author,publishDate: i.datePublished)).toList(),
              ),
              itemCount: searchResults.length,
              itemBuilder: (context,index) {
                return BookCard(title: searchResults[index].title,author: searchResults[index].author,publishDate: searchResults[index].datePublished.toString().split(' ')[0],image: searchResults[index].imageId);
              },
            ),
          ),
        ]
      ):Center(
        child: Text("No Resutls for This Query", style: TextStyle(fontSize: 16),)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBookPage()));},
        tooltip: 'Add A book',
        child: Icon(Icons.add),
      ), 
    );
  }
}