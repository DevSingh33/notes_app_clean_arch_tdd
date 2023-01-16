import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/cubit/notes_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/helperfunctions/show_bottom_sheet.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/pages/notes_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({
    super.key,
  });

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  @override
  void initState() {
    getNotesFromBloc();
    super.initState();
  }

  void getNotesFromBloc() {
    print('getNotesFromBloc() called');
    final bloc = BlocProvider.of<NotesCubit>(context);
    bloc.getAllNotes();
  }

  String? title;
  String? description;

  @override
  Widget build(BuildContext context) {
    print("notes home page build...........");
    // getNotesFromBloc();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: BlocBuilder<NotesCubit, NotesCubitState>(
        builder: (context, state) {
          if (state is NotesCubitError) {
            return Center(child: Text(state.errorMsg));
          } else if (state is NotesCubitLoading) {
            print("loading state");
            return const Center(child: CircularProgressIndicator(backgroundColor: Colors.amber));
          } else if (state is NotesCubitLoaded) {
            final List<NoteEntity>? notes = state.notesList;
            if (notes != null && notes.isEmpty) {
              return const Center(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No Notes Present!",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
              );
            } else if (notes != null && notes.isNotEmpty) {
              print("notes list length: ${notes.length}");
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (ctx, index) {
                      final NoteEntity note = notes[index];
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return BlocProvider<NotesCubit>.value(
                              value: BlocProvider.of<NotesCubit>(context),
                              child: NoteDetails(
                                id: note.id!,
                                title: note.title,
                                description: note.description,
                                dateTime: note.dateTime.substring(0, 16),
                              ),
                            );
                          }),
                        ),
                        child: ListTile(
                          title: Text(
                            note.title,
                          ),
                          subtitle: Text(note.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: Text(note.dateTime.substring(0, 16)),
                        ),
                      );
                    }),
              );
            }
          }
          return const Center(child: SizedBox.shrink());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HelperFunctions.showBottomSheet(isEditNote: false, ctx: context, description: description, title: title);
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
