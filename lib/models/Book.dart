class Book
{
  String title="";
  String author="";
  DateTime datePublished=DateTime.now();

  Book(){
    this.title="";
    this.author="";
    this.datePublished=DateTime.now();
  }

  Book.fromJson(Map<String,dynamic> json)
  {
    title=json['title'];
    author=json['author'];
    datePublished=DateTime.parse(json['DatePublished']);
  }
}