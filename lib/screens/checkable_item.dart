import 'package:flutter/material.dart';
import 'package:flutter_notes/screens/NoteReaderScreen.dart';
import 'package:flutter_notes/widgets/note_card.dart';
import '../models/NotesModels.dart';
//
// enum Priority{urgent,normal,low}

class CheckableItem extends StatefulWidget {
  final String id;
  Notes docs;

  CheckableItem(this.id,this.docs,{super.key});//id of a document,data inside particular document,key of the particular doc whose data is also coming

  @override
  State<CheckableItem> createState() => _CheckableItemState();
}

class _CheckableItemState extends State<CheckableItem> {
  @override
  Widget build(BuildContext context) {
    // var icon=Icons.low_priority;
    //
    // if(widget.priority== Priority.urgent)
    // {
    //   icon=Icons.notifications_active;
    // }
    //
    // if(widget.priority== Priority.normal)
    // {
    //   icon=Icons.list;
    // }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Checkbox(
            value:widget.docs.isChecked, //value takes the bool value to check if the checkbox is checked or not
            onChanged:(value)
            {
            widget.docs.isChecked = value;//here value = false ???
            widget.docs.id = widget.id;//key is being assigned
            setState(() {

            });
          },
          ),

            Expanded(
                child:noteCard(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      //notes reader takes document data and key of document
                      builder: (ctx) => NotesReaderScreen(
                          widget.id,widget.docs),
                    ),
                  );
                }, widget.docs, context,widget.id)
            ),

          ],
        ),
    );
  }
}
