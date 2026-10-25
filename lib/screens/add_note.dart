// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_notes/style/app_style.dart';
// import 'dart:math';
//
// class NoteEditor extends StatefulWidget {
//   const NoteEditor({Key? key}) : super(key: key);
//
//   @override
//   State<NoteEditor> createState() => _NoteEditorState();
// }
//
// class _NoteEditorState extends State<NoteEditor> {
//   int color_id=Random().nextInt(AppStyle.cardsColor.length);
//   String date=DateTime.now().toString();
//   final _titleControlller=TextEditingController();
//   final _mainControlller=TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppStyle.cardsColor[color_id],
//       appBar: AppBar(
//         backgroundColor: AppStyle.cardsColor[color_id],
//         title: Text("Add a new Note"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleControlller,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Note Title'
//               ),
//               style: AppStyle.mainTitle,
//             ),
//            SizedBox(height: 10,),
//             Text(date,style: AppStyle.dateTitle,),
//             TextField(
//               controller: _mainControlller,
//               keyboardType: TextInputType.multiline,
//               decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: 'Note Content'
//               ),
//               style: AppStyle.mainTitle,
//             ),
//             SizedBox(height: 10,),
//           ],
//         ),
//       ),
//             floatingActionButton:FloatingActionButton.extended(
//                 onPressed:()async {
//                   FirebaseFirestore.instance.collection('Notes').add({
//                    "note_title":_titleControlller.text,
//                     "creation_date":date,
//                     "note_content":_mainControlller.text,
//                     "color_id": color_id.toString(),
//                   }).then((value){
//                     Navigator.pop(context);
//                   }).catchError((onError)=>print("Failed to add new note due to $onError"));
//                   //Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteEditor()));
//                 },
//                 label: Text("Add note"),
//                 icon:Icon(Icons.save)
//             ),
//
//     );
//   }
// }
import 'dart:math';
import 'package:flutter_notes/models/NotesModels.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class NotesEditor extends StatefulWidget {
  const NotesEditor({Key? key}) : super(key: key);

  @override
  State<NotesEditor> createState() => _NotesEditorState();
}

class _NotesEditorState extends State<NotesEditor> {
  String now = DateTime.now().toString();
  final titleController = TextEditingController();
  final idController = TextEditingController();
  final passController = TextEditingController();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  bool _isLoading=false;


  //  pickFile() async{
  //  if(pickedFile != null)
  //  {
  //    return Expanded(
  //      child: Container(
  //        color:Colors.lightBlue[100],
  //        child:
  //      ),
  //    )
  //  }
  // }

  Future selectFile() async
  {
    final result= await FilePicker.platform.pickFiles();
        if(result== null)
          {
            return;
          }
        setState(() {
          pickedFile=result.files.first;
        });

  }

  Future uploadFile() async
  {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot =await uploadTask!.whenComplete(() {});

    final urlDownload =await snapshot.ref.getDownloadURL();
    print('Download link :$urlDownload');
    setState(() {
      uploadTask=null;
    });
  }

  @override
  Widget build(BuildContext context) {
    //String date = DateFormat.yMd().format(now);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a note'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration:const InputDecoration(
                      labelText: 'Note Title'
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Text("Date : $dat",
                //   textAlign: TextAlign.start,),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: idController,
                  decoration:const InputDecoration(
                      labelText: 'subtitle'
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),TextField(
                  controller: passController,
                  decoration:const InputDecoration(
                      labelText: 'content'
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //file upload code start

                Row(
                  children: [
                    Container(
                        child:(pickedFile!= null)?
                    Expanded(
                        child: Container(
                          color: Colors.blue[100],
                          child: Center(
                            child:Text(pickedFile!.name),
                          ),
                        )
                    ): Text("Select a file"),

                    ),
                    // Container(
                    // color: Colors.cyan,
                    //   height: 80,
                    //   width: 80,
                    //   child:
                    // ),
                    SizedBox(width: 16,),
                    ElevatedButton(
                        onPressed: selectFile,
                        child: Text("Select file")
                    ),
                  ],
                ),

                //file upload code end
                ElevatedButton(
                    onPressed: () async{
                      //uploadFile();

                      _isLoading=true;
                      final path = 'files/${pickedFile!.name}';
                      final img_name=pickedFile!.name;
                      final file = File(pickedFile!.path!);
                      final ref = FirebaseStorage.instance.ref().child(path);
                      setState(() {
                        uploadTask = ref.putFile(file);
                      });
                      final snapshot =await uploadTask!.whenComplete(() {});

                      final urlDownload =await snapshot.ref.getDownloadURL();
                      print('Download link :$urlDownload');
                      setState(() {
                        uploadTask=null;
                      });
                  final user = FirebaseAuth.instance.currentUser!;
                  //  final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                  FirebaseFirestore.instance.collection('Notes').add({
                    'note_title':titleController.text,
                    'note_date':now,
                    'note_subtitle':idController.text,
                    'note_pass':passController.text,
                    'note_id':user.uid,
                    'note_file':urlDownload,
                    'note_image_name':img_name,
                  }).then((value){
                    Navigator.pop(context);
                  }).catchError((error){
                    print('Failed to add new note due to $error');
                  });

                },
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(90, 40)
                  ),
                  child: (_isLoading)?Center(child:CircularProgressIndicator(color: Colors.lightBlue,)): const Text('Save'),
                ),
              ],
            ),
            ),
        );
    }

  //
  //   //file upload code
  // getfile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc',],
  //   );
  //
  //   if (result != null) {
  //     File c = File(result.files.single.path.toString());
  //     setState(() {
  //       file = c;
  //       name = result.names.toString();
  //     });
  //     uploadFile();
  //   }
  // }
  //
  // getImage() async {
  //   var img = await image.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     file = File(img!.path);
  //   });
  //   if (file != null) {
  //     uploadFile();
  //   }
  // }
  //
  // uploadFile() async {
  //   try {
  //     var imagefile =
  //     FirebaseStorage.instance.ref().child("Users").child("/$name");
  //     UploadTask task = imagefile.putFile(file!);
  //     TaskSnapshot snapshot = await task;
  //     url = await snapshot.ref.getDownloadURL();
  //
  //     print(url);
  //     if (url != null && file != null) {
  //       Fluttertoast.showToast(
  //         msg: "Done Uploaded",
  //         textColor: Colors.red,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: "Something went wrong",
  //         textColor: Colors.red,
  //       );
  //     }
  //   } on Exception catch (e) {
  //     Fluttertoast.showToast(
  //       msg: e.toString(),
  //       textColor: Colors.red,
  //     );
  //   }
  // }
  //
  // //file upload code end
}

