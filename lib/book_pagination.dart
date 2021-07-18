import 'package:bookfinder_app/services/api_calls.dart';
import 'package:flutter/foundation.dart';

import 'models/Book.dart';

class BookPagination extends ChangeNotifier{
  List<Book> books = [];
  var loading = false;
  var page =1;
  List<Book> prev = [];

  BookPagination(){
    getBooks();
  }

  Future<void> getBooks() async
  {
    loading = true;
    notifyListeners();
    List<Book> results = await Services.getBooksByPage(page);
    if(results.isNotEmpty && results!=prev)
    {
      
      if(prev.length==10 || prev.length==0)
      {  
        prev=results;
        books = [...books,...results];
        if(results.length==10)
        page=page+1;
      }
      else{
        
        books.addAll(results.getRange(prev.length, results.length));
        prev=results;
        if(results.length==10)
        page+=1;
      }
    }
    loading=false;
    notifyListeners();
  }


}