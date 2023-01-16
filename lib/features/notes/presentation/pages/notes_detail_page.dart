import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/bloc/cubit/notes_cubit.dart';
import 'package:assign_notes_app_clean_architecture_tdd/features/notes/presentation/helperfunctions/show_bottom_sheet.dart';
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
  @override
  Widget build(BuildContext context) {
    final deviceSettings = MediaQuery.of(context).size;
    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          IconButton(
              onPressed: () {
                final bloc = BlocProvider.of<NotesCubit>(context);

                bloc.deleteANote(widget.id);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HelperFunctions.showBottomSheet(
              isEditNote: true, id: widget.id, ctx: context, title: widget.title, description: widget.description, dateTime: widget.dateTime);
          setState(() { //todo : UI not updating
            print('set state called');
          });
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
}
