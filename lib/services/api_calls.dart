import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/src/asset.dart';
import 'package:bookfinder_app/models/Book.dart';
import 'package:http/http.dart' as http;
class Services{

  //static String emulatorUrl = 'http://10.0.2.2:7000/';
  static String emulatorUrl = 'https://bookfinder-app-backend.herokuapp.com/';
  //static String emulatorUrl = 'http://localhost:7000/';
  static String searchRoute = 'books/search/';
  static String addBookRoute = 'books/';
  static String pageSize = '10';
  String imagesUrl = 'images/';
  Dio dio = Dio();
  //static String host = 'localhost:7000';

  static Future<String> addBook(String title, String author, String datePublished) async {
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
      return json.decode(response.body)['_id'];
      
    }
    catch(err)
    {
      print('error');
      return '';
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


  Future<dynamic> addImageForWeb(Uint8List image, String bookId) async
  { print("hello");
    FormData formData = FormData.fromMap({
        "bookImg": http.MultipartFile.fromBytes('', image),
        "bookId": bookId
      });

      final response = await dio.post(
        emulatorUrl + imagesUrl+"forWeb",
        data: formData,
      );
      print("hello");
      return response;
  }

  Future<Response> addImage(File image, String bookId) async {
    FormData formData = FormData.fromMap({
      "bookImg": await MultipartFile.fromFile(image.path),
      "bookId": bookId
    });

    final response = await dio.post(
      emulatorUrl + imagesUrl,
      data: formData,
    );
    return response;
  
  }
  CachedNetworkImageProvider getBookImage(String imageId) =>
      CachedNetworkImageProvider(emulatorUrl+imagesUrl + imageId);
}