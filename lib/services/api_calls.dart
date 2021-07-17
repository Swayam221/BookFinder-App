import 'dart:convert';

import 'package:bookfinder_app/models/Book.dart';
import 'package:http/http.dart' as http;
class Services{

  static String emulatorUrl = 'http://10.0.2.2:7000/';
  static String searchRoute = 'books/search/';
  static String addBookRoute = 'books/';
  static String pageSize = '10';
  //static String host = 'localhost:7000';

  static Future<void> addBook(String title, String author, String datePublished) async {
    var body = json.encode({
      'title': title,
      'author': author,
      'DatePublished': datePublished
    });
    try{
      final response = await http.post(
        Uri.parse(emulatorUrl+addBookRoute),
        headers: {'content-type': 'application/json'},
        body: body,
      );
      print(json.decode(response.body));
    }
    catch(err)
    {
      print('error');
    }
  } 
  
  static Future<List<Book>> search(String query) async{
    try{
      
      final response = await http.get(
        Uri.parse(emulatorUrl+searchRoute+query),
      );
      List<Book> results = (json.decode(response.body) as List).map((i) => Book.fromJson(i)).toList();
      //print(results[0].title);
      return results;
    }
    catch(err){
      print("error");
      return [];
    }
  }

  static Future<List<Book>> getBooks() async{
    try{
      
      final response = await http.get(
        Uri.parse(emulatorUrl+addBookRoute),
      );
      List<Book> results = (json.decode(response.body) as List).map((i) => Book.fromJson(i)).toList();
      //print(results[0].title);
      return results;
    }
    catch(err){
      print("error");
      return [];
    }
  }


  static Future<List<Book>> getBooksByPage(int page) async{
    try{
      
      final response = await http.get(
        Uri.parse(emulatorUrl+addBookRoute+page.toString()+'/'+pageSize.toString()),
      );
      List<Book> results = (json.decode(response.body) as List).map((i) => Book.fromJson(i)).toList();
      //print(results[0].title);
      return results;
    }
    catch(err){
      print("error");
      return [];
    }
  }
}