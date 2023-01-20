import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/note_cubit/note_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/notes_cubit/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelperFunctions {
  ///[showPrompt] will show the alert dialog to the user
  static void showPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.amberAccent,
          content: Text(
            "Connect to the internet!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  ///[showBottomSheet] will show a bottom sheet for saving or editing of the notes
  static void showBottomSheet({required bool isEditNote, required BuildContext ctx, String? title, String? description, int? id, String? dateTime}) {
    ///[editNote] will access the NotesBloc and NoteBloc and first call the 'editNote()' api then, fetch the new updated notes list from the api
    Future<void> editANote() async {
      final singleNoteBloc = BlocProvider.of<NoteCubit>(ctx);
      final notesBloc = BlocProvider.of<NotesCubit>(ctx);
      await singleNoteBloc.editANote(
        NoteEntity(id: id, title: title!, description: description!, dateTime: dateTime!),
      );
      await notesBloc.getAllNotes();
    }

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  onChanged: ((value) {
                    title = value;
                  }),
                ),
                TextFormField(
                  initialValue: description,
                  minLines: 3,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                  ),
                  onChanged: ((value) {
                    description = value;
                  }),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (isEditNote) {
                        if ((description != null && description!.isNotEmpty) && (id != null)) {
                          editANote();
                          Navigator.pop(ctx);
                        }
                      } else {
                        final notesBloc = BlocProvider.of<NotesCubit>(ctx);
                        if (description != null && description!.isNotEmpty) {
                          notesBloc.saveNote(noteTitle: title, noteDescription: description!);
                          Navigator.pop(ctx);
                        }
                      }
                    },
                    child: const Text("Save")),
                Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom))
              ],
            ),
          ),
        );
      },
    );
  }
}
