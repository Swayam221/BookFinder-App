import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:bookfinder_app/services/api_calls.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddBookPage extends StatefulWidget{

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBookPage>
{
  var titleController = TextEditingController();
  var authorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var date;
  dynamic image;
  dynamic selectedImage;
  List<Asset> temp1 = [];
  List<Asset>  temp2 =[];
  bool  loading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState()
  {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add A Book"),
        leading: Icon(Icons.my_library_books_outlined),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(selectedImage!=null)
              Column(
                children: [
                  !kIsWeb?Image.file(File(selectedImage.path),height: 150,width: 100,):Image.network(selectedImage.path,height: 150,width: 100,),
                  SizedBox(height: 10,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFFE57373),
                                  Color(0xFFEF5350),
                                  Color(0xFFEF5950),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            primary: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedImage = image = null;
                            });
                          },
                          child: const Text('Remove Book Cover'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if(selectedImage==null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () async{
                        if(!kIsWeb)
                        await _fetchImage();
                        else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Cannot Add Image From Web App. Please Use the Android App for uploading an Image")));
                        }
                      },
                      child: const Text('Add Image For Cover'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Title",
                ),
                validator: (val) => val!.isEmpty ? 'the book must have a title': null,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: authorController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Author",
                ),
                validator: (val) => val!.isEmpty ? 'the book must have an author': null,
              ),
              const SizedBox(height: 20,),
              DateTimeFormField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Date of Publication',
                ),
                mode: DateTimeFieldPickerMode.date,
                //autovalidateMode: AutovalidateMode.always,
                validator: (e) => (e==null || e.compareTo(DateTime.now())>0 )?'please enter a valid date': null,
                onDateSelected: (DateTime value) {
                  date = value.toString();
                },
              ),
              const SizedBox(height: 20,),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState!.validate())
                        {
                          setState(() {
                            loading = true;
                          });
                          var response = await Services.addBook(titleController.text,authorController.text,date);
                          if(response=='')
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("An error occured while uploading book details."),
                          ));
                          else if(selectedImage!=null && response!='')
                          {
                            try{
                              
                            await Services().addImage(File(selectedImage.path), response);
                            }
                            catch(err)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("An error occured while uploading image."),
                              ));
                            }
                            
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Book Added to Database Successfully"),
                            ));
                            Navigator.pop(context);
                          }
                          else if(selectedImage==null && response!=''){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Book Added to Database Successfully"),
                            ));
                            Navigator.pop(context);
                          }
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      child: !loading?const Text('Add Book To Database'):CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          ),),
        ),
      ),
    );
  }

  Future<void> _fetchImage() async {
    try {
      image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        selectedImage = image;
      });
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }
}