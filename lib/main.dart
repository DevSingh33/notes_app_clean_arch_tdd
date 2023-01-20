import 'package:assign_notes_app_clean_architecture_tdd/core/singletons/singletons.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/connection_checker_cubit/cubit/connection_checker_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/note_cubit/note_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/notes_cubit/notes_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesCubit>(
          create: (context) => NotesCubit(
            addNoteUseCase: serviceLocator(),
            getNotesUseCase: serviceLocator(),
      
          ),
        ),
        BlocProvider<NoteCubit>(
          create: (context) => NoteCubit(
            getSingleNoteUseCase: serviceLocator(),
            deleteNoteUseCase: serviceLocator(),
            editNoteUseCase: serviceLocator(),
          ),
        ),
        BlocProvider<ConnectionCheckerCubit>(create: (context) => ConnectionCheckerCubit(serviceLocator())),
      ],
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
