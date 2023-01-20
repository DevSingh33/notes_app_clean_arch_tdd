import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/connection_checker_cubit/cubit/connection_checker_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/note_cubit/note_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/notes_cubit/notes_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/helperfunctions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteDetails extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String dateTime;
  const NoteDetails({super.key, required this.id, required this.title, required this.description, required this.dateTime});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  //var to be used(to check if we are connected to internet or not) in floating action button, delete button
  bool isConnected = false;

  @override
  void initState() {
    getNoteFromBloc();
    super.initState();
  }

  //initilize the 'Notes Cubit' and call getAllNotes()
  void getNoteFromBloc() {
    final bloc = BlocProvider.of<NoteCubit>(context);
    bloc.getSingleNote(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSettings = MediaQuery.of(context).size;
    return BlocBuilder<ConnectionCheckerCubit, ConnectionCheckerState>(
      builder: (context, state) {
        if (state is InternetConnected) {
          isConnected = true;
          getNoteFromBloc();
        } else if (state is InternetDisconnected) {
          isConnected = false;
          getNoteFromBloc();
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Note'),
              actions: [
                IconButton(
                    onPressed: () {
                      HelperFunctions.showPrompt(context);
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                HelperFunctions.showPrompt(context);
              },
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 28)),
                    const SizedBox(height: 40),
                    Container(
                      height: deviceSettings.height * 0.6,
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all()),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(widget.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text('Created At: ${widget.dateTime}', style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          );
        }
        return BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is NoteCubitError) {
              return Scaffold(appBar: AppBar(title: const Text('Note')), body: Center(child: Text(state.errorMsg)));
            } else if (state is NoteCubitLoading) {
              return  Scaffold(appBar: AppBar(title: const Text('Note')),body: const Center(child: CircularProgressIndicator(backgroundColor: Colors.amber)));
            } else if (state is NoteCubitLoaded) {
              final NoteEntity noteFromAPi = state.note;
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: const Text('Note'),
                  actions: [
                    IconButton(
                        onPressed: isConnected
                            ? () {
                                final singleNoteBloc = BlocProvider.of<NoteCubit>(context);
                                final notesBloc = BlocProvider.of<NotesCubit>(context);
                                singleNoteBloc.deleteANote(widget.id);
                                notesBloc.getAllNotes();
                                Navigator.pop(context);
                              }
                            : () {
                                HelperFunctions.showPrompt(context);
                              },
                        icon: const Icon(Icons.delete))
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: isConnected
                      ? () {
                          HelperFunctions.showBottomSheet(
                              isEditNote: true,
                              id: widget.id,
                              ctx: context,
                              title: noteFromAPi.title,
                              description: noteFromAPi.description,
                              dateTime: noteFromAPi.dateTime.substring(0, 16));
                        }
                      : () {
                          HelperFunctions.showPrompt(context);
                        },
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(noteFromAPi.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 28)),
                        const SizedBox(height: 40),
                        Container(
                          height: deviceSettings.height * 0.6,
                          width: double.infinity,
                          decoration: BoxDecoration(border: Border.all()),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(noteFromAPi.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text('Created At: ${noteFromAPi.dateTime.substring(0, 16)}', style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Scaffold(
                body: SizedBox.shrink(),
              );
            }
          },
        );
      },
    );
  }
}
