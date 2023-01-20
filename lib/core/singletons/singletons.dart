import 'package:assign_notes_app_clean_architecture_tdd/core/network/connection_checker.dart';
import 'package:assign_notes_app_clean_architecture_tdd/core/services/local_db.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/local_datasource.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/remote_datasource.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/repositories/notes_repository.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/add_note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/delete_note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/edit_note.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/get_notes.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/usecases/get_single_note.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final serviceLocator = GetIt.I;

///[initSingletons] will initialize all the required dependenices (Use Cases, Repository,Data Source, Database Service) as a singleton
Future<void> initSingletons() async {
  //-------------------------------------- Data--------------------------------------------
  //! Data Source
  serviceLocator.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(dbService: serviceLocator()));
  serviceLocator.registerLazySingleton<NotesRemoteDataSource>(() => NotesRemoteDataSourceImpl(dioClient: serviceLocator()));


  //--------------------------------------- Domain ------------------------------------------
  //!Repository
  serviceLocator.registerLazySingleton<NotesRepository>(
      () => NotesRepositoryImpl(remoteDataSource: serviceLocator(), localDataSource: serviceLocator(), connectionChecker: serviceLocator()));
  
  //------------------------------------------ Presentation ---------------------------
  //! USE CASES
  serviceLocator.registerLazySingleton(() => AddNote(notesRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteNote(notesRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => EditNote(notesRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetNotes(notesRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetSingleNote(notesRepository: serviceLocator()));



  //!Core
  serviceLocator.registerLazySingleton<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()));


//------------------------------- External------------------------------------
  //! Database Service
  serviceLocator.registerLazySingleton(() => DbService());

  //!Dio Service
  serviceLocator.registerLazySingleton<Dio>(() => Dio());

  //!ConnectionChecker
  serviceLocator.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
}
