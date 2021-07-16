import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget{
  final title;
  final author;
  final publishDate;
  BookCard({this.title,this.author,this.publishDate});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child:Text(title)),
          Expanded(child:Text(author)),
          Expanded(child:Text(publishDate.toString().split(' ')[0]))
        ],
      ),
    );
  }
  
}