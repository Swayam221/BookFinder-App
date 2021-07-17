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
        //mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(image!=null)
          Image(
            image: getImage(),width: 120,
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
          Image.asset('default_book_cover_2015.png',width: 120,),
          Flexible(child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                      
                Flexible(child:Text(title,textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),overflow: TextOverflow.visible,maxLines: 3,),),
                SizedBox(height: 8,),
                Flexible(child:Text("by\n"+author,textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
                SizedBox(height: 8),
                Flexible(child:Text("published: "+publishDate.toString().split(' ')[0],textAlign: TextAlign.center,),)
              ],
            ),
          ),),
        ],
      ),
    );
  }
  
}