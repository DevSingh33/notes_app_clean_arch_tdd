import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/cubit/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelperFunctions {
  static void showBottomSheet({required bool isEditNote, required BuildContext ctx, String? title, String? description, int? id, String? dateTime}) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        print('note: id : $id, title: $title, description: $description, dateTime: $dateTime');
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
                      final bloc = BlocProvider.of<NotesCubit>(ctx);
                      if (isEditNote) {
                        print('editting note');

                        if ((description != null && description!.isNotEmpty) && (id != null)) {
                          bloc.editANote(
                            NoteEntity(id: id, title: title!, description: description!, dateTime: dateTime!),
                          );
                          Navigator.pop(ctx);
                        }
                      } else {
                        print('creating new note');
                        if (description != null && description!.isNotEmpty) {
                          bloc.saveNote(noteTitle: title, noteDescription: description!);
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
