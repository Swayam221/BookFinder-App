import 'package:bookfinder_app/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/change_notifier_provider.dart';

import 'book_pagination.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider<BookPagination>(
        create: (context) => BookPagination(),
        child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bookfinder App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(title: 'Look A Book'),
      ),
    );
  }
}

