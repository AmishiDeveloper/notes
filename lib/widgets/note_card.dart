// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_notes/style/app_style.dart';
//
// Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc)
// {
//   return InkWell(
//     onTap: onTap,
//     child: Container(
//       padding: EdgeInsets.all(8),
//       margin: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border:Border.symmetric(),
//         color: AppStyle.cardsColor[doc['color_id']],
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         children: [
//           Text(doc["note_title"],style: AppStyle.mainTitle,),
//           SizedBox(height: 4,),
//           Text(doc["creation_date"],style: AppStyle.mainTitle,),
//           SizedBox(height: 4,),
//           Text(doc["note_content"],style: AppStyle.mainContent,overflow: TextOverflow.ellipsis,),
//         ],
//       ),
//     ),
//   );
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/models/NotesModels.dart';

Widget noteCard(VoidCallback onTap,Notes doc,BuildContext context,String Id,){
  return Container(
      padding: const EdgeInsets.all(8),
      // margin:const  EdgeInsets.all(8),
      width: double.infinity,
      child: Card(
          elevation: 2,
          color: Theme.of(context).colorScheme.primary,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin:const  EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text(doc.title.toString(),
                        style:const TextStyle(fontSize: 25),
                      ),
                      IconButton(
                          onPressed: () async{
                        FirebaseStorage.instance.refFromURL(doc.file.toString()).delete();
                        FirebaseFirestore.instance.collection('Notes').doc(Id).delete();
                      }, icon:const Icon(Icons.delete))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(doc.noteId.toString(),),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(doc.password.toString(),),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(doc.date.toString(),),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(doc.name.toString(),),
                  const SizedBox(
                    height: 4,
                  ),

                ],
              ),
            ),
          ),
          ),
      );
}
