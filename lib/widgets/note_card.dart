import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.note,
    this.onArchive,
    this.onDelete,
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
          direction: DismissDirection.horizontal,
          
          background: _buildActionBackground(
            alignment: Alignment.centerLeft,
            color: Colors.red.shade400,
            icon: Icons.delete_outlined,
            label: 'Trash',
          ),
          
          secondaryBackground: _buildActionBackground(
            alignment: Alignment.centerRight,
            color: Colors.blueGrey.shade400,
            icon: Icons.archive_outlined,
            label: 'Archive',
          ),
        
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              onDelete?.call();
            } else if (direction == DismissDirection.endToStart) {
              onArchive?.call();
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
    elevation: 0, // خليت الظل بره في الـ Container أو ممكن تنقله هنا
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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