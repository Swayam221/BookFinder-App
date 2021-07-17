class Book
{
  String title="";
  String author="";
  DateTime datePublished=DateTime.now();
  String imageId = "";

  Book(){
    this.title="";
    this.author="";
    this.imageId = "";
    this.datePublished=DateTime.now();
  }

  Book.fromJson(Map<String,dynamic> json)
  {
    imageId = json['image'];
    title=json['title'];
    author=json['author'];
    datePublished=DateTime.parse(json['DatePublished']);
  }
}