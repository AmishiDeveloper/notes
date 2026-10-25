// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_notes/style/app_style.dart';
//
// class NoteReaderScreen extends StatefulWidget {
//   const NoteReaderScreen(this.doc,{super.key});
//   final QueryDocumentSnapshot doc;
//
//   @override
//   State<NoteReaderScreen> createState() => _NoteReaderScreenState();
// }
//
// class _NoteReaderScreenState extends State<NoteReaderScreen> {
//   @override
//   Widget build(BuildContext context) {
//     int color_id=widget.doc['color_id'];
//     return Scaffold(
//       backgroundColor: AppStyle.cardsColor[color_id],
//       appBar: AppBar(
//         backgroundColor: AppStyle.cardsColor[color_id],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text(widget.doc["note_title"],style: AppStyle.mainTitle,),
//             SizedBox(height: 4,),
//             Text(widget.doc["creation_date"],style: AppStyle.mainTitle,),
//             SizedBox(height: 4,),
//             Text(widget.doc["note_content"],style: AppStyle.mainContent,overflow: TextOverflow.ellipsis,),
//            // Text(widget.doc["color_id"],style: AppStyle.mainTitle,),
//             SizedBox(height: 4,),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_notes/models/NotesModels.dart';

class NotesReaderScreen extends StatefulWidget {
  NotesReaderScreen(this.ID, this.docs, {Key? key}) : super(key: key);
  Notes docs;
  final String ID;

  @override
  State<NotesReaderScreen> createState() => _NotesReaderScreenState();
}

class _NotesReaderScreenState extends State<NotesReaderScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  var urlDownload;
  String? img_name;
  String? ref;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        //allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'mp3', 'docx', 'txt', 'pdf', 'exl']);
    if (result == null) {
      return;
    }
    setState(() {
      pickedFile = result.files.first;
      //(result!.files);
    });
  }

  // void loadedSelectedFiles(List<PlatformFile> files)
  // {
  //   final List<PlatformFile> files;
  //   //final ValueChanged<PlatformFile>
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.docs.title.toString();
    idController.text = widget.docs.noteId.toString();
    passController.text = widget.docs.password.toString();
    // titleController = widget.docs['note_title'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(widget.docs.date.toString()),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: idController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: passController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              Row(
                children: [
                  Container(
                    color: Colors.cyan,
                    height: 350,
                    width: 250,
                    //flex: ,
                    child: //InkWell(
                        // child:
                        //CircleAvatar(
                        //color: Colors.blue[100],
                        //child:
                        //child:
                        (pickedFile == null)
                            ? //Image.network(widget.docs['note_file'],fit: BoxFit.fill,)
                            CachedNetworkImage(
                                imageUrl: widget.docs.file.toString(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const Center(child:CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.file(
                                File(pickedFile!.path.toString()),
                                fit: BoxFit.fill,
                              ),
                    // InkWell(
                    //   child:(pickedFile!.name == null)?Text(widget.docs['note_img_name']):Text(widget.docs['note_file']),
                    //   onTap: (){
                    //    UploadFileShow();
                    //   },
                    // ),
                  ),
                  //),
                  //),
                  //),
                  // Container(
                  // color: Colors.cyan,
                  //   height: 80,
                  //   width: 80,
                  //   child:
                  // ),
                  SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      onPressed: selectFile, child: Text("Change File")),
                ],
              ),

              // ElevatedButton(
              //     onPressed: () async {
              //       //uploadFile();
              //       final path = 'files/${pickedFile!.name}';
              //       img_name = pickedFile!.name;
              //       final file = File(pickedFile!.path!);
              //       final ref = FirebaseStorage.instance.ref().child(path);
              //       setState(() {
              //         uploadTask = ref.putFile(file);
              //       });
              //       final snapshot = await uploadTask!.whenComplete(() {});
              //
              //       final urlDownload = await snapshot.ref.getDownloadURL();
              //       print('Download link :$urlDownload');
              //       setState(() {
              //         uploadTask = null;
              //       });
              //     },
              //     child: const Text('Save')),

              ElevatedButton(
                onPressed: () async {
                  final path = 'files/${pickedFile!.name}';
                  img_name = pickedFile!.name;
                  final file = File(pickedFile!.path!);
                  final ref = FirebaseStorage.instance.ref().child(path);
              //    final pth = await ref.fullPath;
                  setState(() {
                    uploadTask = ref.putFile(file);
                  });
                  final snapshot = await uploadTask!.whenComplete(() {});

                  final urlDownload = await snapshot.ref.getDownloadURL();
                  print('Download link :$urlDownload');
                  setState(() {
                    uploadTask = null;
                  });
                  FirebaseStorage.instance
                      .refFromURL(widget.docs.file.toString())
                      .delete();

                  FirebaseFirestore.instance
                      .collection('Notes')
                      .doc(widget.ID)
                      .update({
                    'note_title': titleController.text,
                    'note_date': widget.docs.date.toString(),
                    'note_subtitle': idController.text,
                    'note_pass': passController.text,
                    'note_file': urlDownload,
                    'note_image_name': img_name,
                  }).then((value) {
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Failed to add new note due to $error');
                  });
                },
                child: const Text('Edit'),
              ),
              // Text(widget.docs['note_id'],),
              // const SizedBox(
              //   height: 4,
              // ),
              // Text(widget.docs['note_pass'],),
              // const SizedBox(
              //   height: 4,
              // ),
              // Text(widget.docs['note_date'],),
            ],
          ),
        ),
      ),
    );
  }
}
