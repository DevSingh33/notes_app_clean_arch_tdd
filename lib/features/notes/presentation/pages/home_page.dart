import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/connection_checker_cubit/cubit/connection_checker_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/notes_cubit/notes_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/helperfunctions/helper_functions.dart';
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
  //var to be used(to check if we are connected to internet or not) in floating action button
  bool isConnected = false;

  @override
  void initState() {
    checkForInternet();
    getNotesFromBloc();
    super.initState();
  }

  //initilize the 'Notes Cubit' and call getAllNotes()
  void getNotesFromBloc() {
    final bloc = BlocProvider.of<NotesCubit>(context);
    bloc.getAllNotes();
  }

  // //initilize the 'Notes Cubit' and call getAllNotesFromLocal()
  // void getLocalNotesFromBloc() {
  //   final bloc = BlocProvider.of<NotesCubit>(context);
  //   bloc.getAllNotesFromLocal();
  // }

  void checkForInternet() {
    final bloc = BlocProvider.of<ConnectionCheckerCubit>(context);
    bloc.checkInternet();
  }

  String? title;
  String? description;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectionCheckerCubit, ConnectionCheckerState>(
      listener: (context, state) {
        if (state is InternetConnected) {
          // isConnected = true;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.lightGreen, content: Text("Online")));
        } else if (state is InternetDisconnected) {
          // isConnected = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.redAccent, content: Text("Offline")));
        }
      },
      builder: (context, state) {
        if (state is InternetConnected) {
          isConnected = true;
          getNotesFromBloc();
        } else if (state is InternetDisconnected) {
          isConnected = false;
          getNotesFromBloc();
        } else if (state is ConnectionCheckerLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(backgroundColor: Colors.amber)));
        }
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
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (ctx, index) {
                          final NoteEntity note = notes[index];
                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return NoteDetails(
                                  id: note.id!,
                                  title: note.title,
                                  description: note.description,
                                  dateTime: note.dateTime.substring(0, 16),
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
            onPressed: isConnected
                ? () {
                    HelperFunctions.showBottomSheet(isEditNote: false, ctx: context, description: description, title: title);
                  }
                : () {
                    HelperFunctions.showPrompt(context);
                  },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
