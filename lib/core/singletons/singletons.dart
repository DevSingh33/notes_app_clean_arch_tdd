import 'package:assign_notes_app_clean_architecture_tdd/core/services/local_db.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/remote_datasource.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/repositories/notes_repository_remote_impl.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/add_note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/delete_note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/edit_note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/get_notes.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.I;

///[initSingletons] will initialize all the required dependenices (Use Cases, Repository,Data Source, Database Service) as a singleton
Future<void> initSingletons() async {
  //! USE CASES
  serviceLocator.registerLazySingleton(() => AddNote(notesRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteNote(notesRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => EditNote(notesRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetNotes(notesRepository: serviceLocator()));

  //! Repository (uncomment to use local data source dependency with NoteRepository)
  // serviceLocator.registerLazySingleton<NotesRepository>(() => NotesRepositoryImpl(localDataSource: serviceLocator()));  /
  //! Remote Repository
  serviceLocator.registerLazySingleton<NotesRepository>(() => NotesRepositoryRemoteImpl(remoteDataSource: serviceLocator()));

  //! Data Source Repository (uncomment to use local data source)
  // serviceLocator.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(dbService: serviceLocator()));
  serviceLocator.registerLazySingleton<NotesRemoteDataSource>(() => NotesRemoteDataSourceImpl());

  //! Database Service
  serviceLocator.registerLazySingleton(() => DbService());

  //!Dio Service
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
}
