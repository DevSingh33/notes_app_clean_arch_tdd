import 'dart:convert';
import 'dart:io';

import 'package:assign_notes_app_clean_architecture_tdd/features/notes/data/models/note_model.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/domain/entities/note.dart';
import 'package:flutter_test/flutter_test.dart';

String fixture(String fileName) =>
    File('test/fixtures/$fileName').readAsStringSync();

void main() {
  const tNoteModel = NoteModel(noteDescription: "noteDescription", noteDateTime: "noteDateTime", noteTitle: "noteTitle");

  test('should verify [NoteModel] is subclass of [NoteEntity] ', () {
    //arrange
    //act
    //assert
    expect(tNoteModel, isA<NoteEntity>());
  });

  test('should convert json data to [NoteModel]', () {
    //arrange
    //act
    final note = NoteModel.fromJson(json.decode(fixture('note.json')));
    //assert
    expect(note, equals(tNoteModel));
  });

  test('should convert [NoteModel] to json data', () {
    //arrange
    final noteJson = json.decode(fixture('note.json'));
    //act
    final note = tNoteModel.toJson();
    //assert
    expect(note, equals(noteJson));
  });
}