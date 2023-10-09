import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesbook/Pages/add_new_note.dart';
import 'package:notesbook/providers/notes_provider.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return  Scaffold(
      appBar: AppBar(
        title: const Text('NoteBook'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: (notesProvider.isLoading == false)?SafeArea(
        child:(notesProvider.notes.length >0) ? ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    searchQuery=val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search"
                ),
              ),
            ),





            (notesProvider.getFilteredNotes(searchQuery).length > 0) ? GridView.builder(
              physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: notesProvider.getFilteredNotes(searchQuery).length,
                itemBuilder: (context,index) {
                  Note currentNote = notesProvider.getFilteredNotes(searchQuery)[index];
                  return GestureDetector(
                    onTap: () {
                      //update
                      Navigator.push(context,
                        CupertinoPageRoute(builder: (context)=>AddNewNotePage(
                          isUpdate: true,
                          note: currentNote,
                        )),
                      );
                    },
                    onLongPress: () {
                      //to delete
                      notesProvider.deleteNote(currentNote);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentNote.title!,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          const SizedBox(height: 7,),
                          Text(currentNote.content!,style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),maxLines: 6,overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                    ),
                  );
                },
            ):Padding(
              padding: EdgeInsets.all(20),

              child: Text("Sorry!! No Notes Found",textAlign: TextAlign.center,),
            ),
          ],
        ): Center(
          child: Text("Note is Empty!!!!"),
        ),
      ):Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
          CupertinoPageRoute(
            fullscreenDialog: true,
              builder: (context)=>const AddNewNotePage(
                isUpdate: false,
              )
          ),
          );
        },
        child: const Icon(Icons.add,color: Colors.blue,),
      ),
    );
  }
}
