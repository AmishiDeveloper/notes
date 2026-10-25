// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_notes/screens/NoteReaderScreen.dart';
// import 'package:flutter_notes/screens/add_note.dart';
// import 'package:flutter_notes/style/app_style.dart';
// import 'package:flutter_notes/widgets/note_card.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppStyle.mainColor,
//       appBar: AppBar(
//         title: Text("Notes",
//           style: TextStyle(fontWeight: FontWeight.w500,fontSize:25),
//         ) ,
//         centerTitle: true,
//         actions: [
//           IconButton(onPressed: (){
//             FirebaseAuth.instance.signOut();
//             exit(0);
//             },
//               icon: Icon(Icons.clear)
//           ),
//         ],
//       ),
//       body: Column(
//
//         children: [
//           Text("Your recent Notes",style: GoogleFonts.roboto(color: Colors.white),),
//           SizedBox(height: 15,),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//                 stream:FirebaseFirestore.instance.collection('Notes').snapshots() ,
//                 builder:(ctx, AsyncSnapshot <QuerySnapshot> noteSnapshots) {
//                   if (noteSnapshots.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   if (noteSnapshots.hasError) {
//                     return const Center(
//                       child: Text('Something went wrong...'),
//                     );
//                   }
//                   if (noteSnapshots.hasData) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                         itemCount: noteSnapshots.data!.docs.length, //number of rows
//                         itemBuilder: (context, index) {
//                           final data=noteSnapshots.data!.docs[index];
//                           return noteCard((){},data);
//                           //final  documentSnapshot = noteSnapshots.data!.docs[index];
//                           // return Column(
//                           //     children:noteSnapshots.data!.docs.map((note)=>noteCard(() {},note)).toList(),
//                           // );
//                           //Text(data["note_content"],style: TextStyle(color: Colors.white).
//                         }
//                     );
//                   }
//                   return Text("There is no notes ",style: TextStyle(color: Colors.white),);
//                 }
//                 ),
//           ),
//         ],
//       ),
//         floatingActionButton:FloatingActionButton.extended(
//               onPressed:(){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteEditor()));
//               },
//               label: Text("Add note"),
//               icon:Icon(Icons.add)
//         ),
//
//     );
//   }
// }

//return Column(
//     children:noteSnapshots.data!.docs.map((note)=>noteCard(() {},note)).toList(),
// );

//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/screens/LoginScreen.dart';
import 'package:flutter_notes/screens/checkable_item.dart';
import '../models/NotesModels.dart';
import 'add_note.dart';

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  List<String> multipleSelection = [];
  bool value =false;
  List<Notes> notesList=[];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                //exit(0);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                    (route) => false);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.onBackground,
              )),
          IconButton(
              onPressed: (){
            notesList.forEach((element) {
              if(element.isChecked == true){
                FirebaseStorage.instance.refFromURL(element.file.toString()).delete();
                FirebaseFirestore.instance.collection('Notes').doc(element.id).delete();
              }
            });
          }, icon: Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Your Recent Notes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.teal,
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Notes').where("note_id", isEqualTo: user.uid).snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    //snapshots data property to access notes collection to get hold of diff notes documnents
                    final data =snapshot.data?.docs;//(list of notes documents in firebase)is it a list of collection of notes documents in the firebase (firestore)
                    //e is document of notes in firebase
                    notesList = data!.map((e) =>Notes.fromJson(e.data())).toList();//notesList contains sublist of Notes type data which is coming from firebase in json form which is converted to string using notes cons func

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,//total no of documents present in  notes collection//could it be notesList .length
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          final datas=notesList[index];//ek poori list obj ie here it is sublist of Note type data
                          return CheckableItem(
                              key:ObjectKey(Notes),
                              data[index].id, datas);
                          //InkWell(child:

                          //     Row(
                          //   children: [
                          //     // Checkbox(
                          //     //     value: this.value,
                          //     //     onChanged: (bool ?value) {
                          //     //       multipleSelection=[];
                          //     //       setState(() {
                          //     //         this.value=value!;
                          //     //         if(value== true) {
                          //     //           multipleSelection.add(documentSnapshot.id);
                          //     //           print(multipleSelection);
                          //     //         }
                          //     //         if(value==false)
                          //     //           {
                          //     //             this.value = value!;
                          //     //             multipleSelection.remove(documentSnapshot.id);
                          //     //             print(multipleSelection);
                          //     //           }
                          //     //
                          //     //       });
                          //     //     },
                          //     //   ),
                          //
                          //     Expanded(
                          //         child:noteCard(() {
                          //       Navigator.of(context).push(
                          //         MaterialPageRoute(
                          //           builder: (ctx) => NotesReaderScreen(
                          //               data[index].id,datas),
                          //         ),
                          //       );
                          //     }, datas, context,data[index].id)
                          //     ),
                          //
                          //   ],
                          // );
                        });
                  }
                  return const Text("No data given");
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => NotesEditor()));
        },
        label: const Text('Add Notes'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
