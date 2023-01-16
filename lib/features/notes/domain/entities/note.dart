import 'package:equatable/equatable.dart';

///[NoteEntity] is the main object class for   all [note] properties and will be used in UI presentation
class NoteEntity extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String dateTime;
  const NoteEntity({ this.id,required this.title, required this.description, required this.dateTime});

  @override
  List<Object?> get props => [id,title, description, dateTime];
}
