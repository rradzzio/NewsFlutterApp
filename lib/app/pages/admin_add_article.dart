import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/app/providers.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/utils/snackbars.dart';
import 'package:news_app/widgets/input_field.dart';

class AdminAddArticlePage extends ConsumerStatefulWidget {
  const AdminAddArticlePage({Key? key}) : super(key: key);
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminAddArticlePageState();
}

class _AdminAddArticlePageState extends ConsumerState<AdminAddArticlePage> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an Article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomInputField(
                inputController: titleController, 
                hintText: "Article's title", 
                labelText: "Article's title"
              ),
              const SizedBox(height: 15),
              CustomInputField(
                inputController: descriptionController, 
                hintText: "Article's description", 
                labelText: "Article's description"
              ),
              const SizedBox(height: 15),
              Consumer(
                builder: (context, ref, child) {
                  final image = ref.watch(pickImageProvider);
                  return image == null 
                    ? const Text('No image selected.') 
                    : Image.file(
                      File(image.path),
                      height: 300,
                    );
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async { 
                  final image = await ImagePicker()
                    .pickImage(source: ImageSource.gallery);
                  if(image != null) {
                    ref.watch(pickImageProvider.state).state = image; 
                  }
                }, 
                child: const Text('Pick an image')
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () { 
                  _addArticle(); 
                }, 
                child: const Text('Add the article')
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addArticle() async {
    final firestoreDB = ref.read(databaseProvider);
    final imagePicker = ref.read(pickImageProvider);
    final storage = ref.read(storageProvider);

    if(firestoreDB == null || imagePicker == null || storage == null) return;

    final url = await storage.uploadImage(imagePicker.path);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);

    await firestoreDB.addArticle(
      Article(
        title: titleController.text, 
        description: descriptionController.text, 
        imageUrl: url,
        timestamp: formattedDate,
      )
    );

    openIconSnackBar(
      context, 
      'Added the article', 
      const Icon(
        Icons.check,
        color: Colors.white,
      )
    );

    Navigator.pop(context);
  }

}

