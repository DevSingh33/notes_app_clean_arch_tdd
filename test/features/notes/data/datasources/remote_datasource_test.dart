import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/datasources/remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements Dio {}

//todo: write testing code
void main() {
  late NotesRemoteDataSourceImpl remoteDataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    remoteDataSource = NotesRemoteDataSourceImpl(dioClient: mockDioClient);
  });

  const tGetNotesUrl = 'http://localhost:9000/api/notes/';

  group('remote source - getAllNotes() ', () {
    test('should perform GET request on the url ', () {
      //arrange
      // when(()=>mockDioClient.get(tGetNotesUrl)).thenAnswer((_) async=> ResponseBody())
    });
  });
}
