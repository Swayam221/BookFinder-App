class Book
{
  String title="";
  String author="";
  DateTime datePublished=DateTime.now();
  String imageId = "";
  String id = "";
  Book(){
    this.id = "";
    this.title="";
    this.author="";
    this.imageId = "";
    this.datePublished=DateTime.now();
  }

  Book.fromJson(Map<String,dynamic> json)
  {
    id = json['_id'];
    imageId = json['image'];
    title=json['title'];
    author=json['author'];
    datePublished=DateTime.parse(json['DatePublished']);
  }
}