import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/screens/layouts/add_edit_note_screen.dart';
import 'package:notes_app/states/notes_cubit.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final String type;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: SizedBox(
        height: 90,
        child: Dismissible(
          key: ValueKey(note.title + note.content),
          direction: type == 'trash'? 
          DismissDirection.startToEnd : DismissDirection.horizontal,
          
          background: _buildActionBackground(
            alignment: Alignment.centerLeft,
            color: type == 'trash'? 
            Colors.green.shade400 : Colors.red.shade400,
            icon: type == 'trash'? 
            Icons.restore : Icons.delete_outlined,
            label: type == 'trash'? 
            'Restore' : 'Trash',
          ),
          
          secondaryBackground: _buildActionBackground(
            alignment: Alignment.centerRight,
            color: type == 'active'?
            Colors.blueGrey.shade400 : Colors.green.shade400,
            icon: type == 'active'?
            Icons.archive_outlined : Icons.restore,
            label: type == 'active'?
            'Archive' : 'Restore',
          ),
        
          confirmDismiss: (direction) async {
            if (type == 'active') {
              if (direction == DismissDirection.startToEnd) {
                context.read<NotesCubit>().trashNote(note, type);
              } else if (direction == DismissDirection.endToStart) {
                context.read<NotesCubit>().archiveNote(note);
              }
            }
          
            else if (type == 'archive') {
              if (direction == DismissDirection.startToEnd) {
                context.read<NotesCubit>().trashNote(note, type);
              } else if (direction == DismissDirection.endToStart) {
                context.read<NotesCubit>().restoreNote(note, type);
              }
            }
          
            else if (type == 'trash') {
              if (direction == DismissDirection.startToEnd) {
                context.read<NotesCubit>().restoreNote(note, type);
              }
            }
            return false;
          },
          child: _buildCardContent(context),
        ),
      ),
    );
  }

  Widget _buildActionBackground({
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: alignment == Alignment.centerLeft ? 
        CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Material(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(16),
    elevation: 0, 
    child: InkWell(
      onTap: () {
        Navigator.push (context,
          MaterialPageRoute
          (
            builder: (context)=>AddEditNoteScreen(initialTitle: note.title, initialContent: note.content, initialPreviewMode: true,)
          )
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).brightness == Brightness.dark?
              Colors.grey.shade400 : Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
    ),
    );
  }
}