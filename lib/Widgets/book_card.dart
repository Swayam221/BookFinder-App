import 'package:bookfinder_app/services/api_calls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget{
  final title;
  final author;
  final publishDate;
  final image;
  BookCard({this.title,this.author,this.publishDate,this.image});

  CachedNetworkImageProvider getImage()
  {
    return Services().getBookImage(image);
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if(image!=null)
          Image(
            image: getImage(),height: 150,width: 100,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
          if(image==null)
          Image.asset('default_book_cover_2015.png',height: 150,width: 100,),
          Expanded(child:Text(title)),
          Expanded(child:Text(author)),
          Expanded(child:Text(publishDate.toString().split(' ')[0]))
        ],
      ),
    );
  }
  
}