import 'package:assign_notes_app_clean_architecture_tdd/core/singletons/singletons.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/cubit/notes_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSingletons();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesCubit>(
      create: (context) => NotesCubit(
          addNoteUseCase: serviceLocator(),
          deleteNoteUseCase: serviceLocator(),
          editNoteUseCase: serviceLocator(),
          getNotesUseCase: serviceLocator(),
        ),
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          home: const NotesHomePage()),
    );
  }
}

