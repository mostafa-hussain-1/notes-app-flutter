import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/states/notes_cubit.dart';

class AddEditNoteScreen extends StatefulWidget {
  final NoteModel? note;
  final bool? initialIsMarkdown;
  final bool initialPreviewMode;
  const AddEditNoteScreen({
    super.key,
    this.note,
    this.initialIsMarkdown = false,
    this.initialPreviewMode = false,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _contentController = TextEditingController();
  late bool _isMarkdownEnable;
  late bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title; 
      _contentController.text = widget.note!.content;
    }
    _isMarkdownEnable = widget.initialIsMarkdown ?? false;
    _isPreviewMode = widget.initialPreviewMode;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _insertMarkdown(String prefix, [String suffix = '']) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    final start = selection.start;
    final end = selection.end;

    // لو المؤشر في مكان غير محدد أو في البداية
    if (start < 0 || end < 0) {
      _contentController.text = text + prefix + suffix;
      return;
    }

    // 1. لو المستخدم محدد كلمة معينة (Selected Text)
    if (start != end) {
      final selectedText = text.substring(start, end);

      // التحقق: هل الكلمة المحددة بداخلها الرموز بالفعل؟
      if (suffix.isNotEmpty &&
          selectedText.startsWith(prefix) &&
          selectedText.endsWith(suffix) &&
          selectedText.length >= prefix.length + suffix.length) {
        // إلغاء التنسيق (حذف الرموز من البداية والنهاية)
        final unwrappedText = selectedText.substring(
          prefix.length,
          selectedText.length - suffix.length,
        );
        _contentController.text = text.replaceRange(start, end, unwrappedText);
        _contentController.selection = TextSelection(
          baseOffset: start,
          extentOffset: start + unwrappedText.length,
        );
        return;
      }

      // التحقق: هل الرموز موجودة خارج الكلمة المحددة مباشرة؟
      if (suffix.isNotEmpty &&
          start >= prefix.length &&
          end + suffix.length <= text.length &&
          text.substring(start - prefix.length, start) == prefix &&
          text.substring(end, end + suffix.length) == suffix) {
        // إلغاء التنسيق بحذف الرموز المحيطة بالنص
        final newText =
            text.substring(0, start - prefix.length) +
            selectedText +
            text.substring(end + suffix.length);
        _contentController.text = newText;
        _contentController.selection = TextSelection(
          baseOffset: start - prefix.length,
          extentOffset: end - prefix.length,
        );
        return;
      }

      // إضافة التنسيق العادي إذا لم يكن موجوداً
      final newText = text.replaceRange(
        start,
        end,
        '$prefix$selectedText$suffix',
      );
      _contentController.text = newText;
      _contentController.selection = TextSelection(
        baseOffset: start + prefix.length,
        extentOffset: end + prefix.length,
      );
    } else {
      // 2. لو مفيش نص محدد ومجرد المؤشر واقف
      final newText = text.replaceRange(start, end, '$prefix$suffix');
      _contentController.text = newText;
      _contentController.selection = TextSelection.collapsed(
        offset: start + prefix.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final currentTitle = _titleController.text.trim();
        final currentContent = _contentController.text.trim();
        final initialTitle = widget.note?.title.trim() ?? '';
        final initialContent = widget.note?.content.trim() ?? '';

        final hasChanges =
            currentTitle != initialTitle || currentContent != initialContent;

        if (!hasChanges) {
          Navigator.pop(context);
          return;
        }

        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ignore Changes?'),
            content: const Text('Exit and Discard the Changes?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Exit',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        );

        if (shouldLeave == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isPreviewMode
                ? 'Note Preview'
                : ((widget.note?.title != null ||
                          widget.note?.content != null)
                      ? 'Edit Note'
                      : 'Add Note'),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isPreviewMode = !_isPreviewMode;
                });
              },
              icon: Icon(_isPreviewMode ? Icons.edit : Icons.visibility),
              tooltip: _isPreviewMode ? 'Edit' : 'Preview',
            ),

            IconButton(
              icon: const Icon(Icons.check),
              tooltip: "Save",
              onPressed: () {
                String title = _titleController.text.trim();
                final content = _contentController.text.trim();

                if (title.isEmpty && content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Can't be Empty"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                if (title.isEmpty) {
                  final words = content
                      .split(RegExp(r'\s+'))
                      .where((w) => w.isNotEmpty)
                      .toList();
                  if (words.length >= 2) {
                    title = '${words[0]} ${words[1]}';
                  } else if (words.length == 1) {
                    title = words[0];
                  } else {
                    title = 'No Title';
                  }
                }

                if (widget.note == null) {
                  NoteModel newNote = NoteModel(
                    title: title, 
                    content: content,
                  );
                  context.read<NotesCubit>().addNote(newNote);

                } else {
                  NoteModel updatedNote = NoteModel(
                    id: widget.note!.id,
                    title: title,
                    content: content,
                  );
                  updatedNote.type = widget.note!.type;
                  context.read<NotesCubit>().updateNote(updatedNote);
                }

                Navigator.pop(context, {
                  'title': title,
                  'content': content,
                  'isMarkdown': _isMarkdownEnable,
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Column(
            children: [
              if (!_isPreviewMode)
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

              if (_titleController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _titleController.text,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (!_isPreviewMode) const Divider(),
              if (!_isPreviewMode)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Markdown Mode'),
                  value: _isMarkdownEnable,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (bool? value) {
                    setState(() {
                      _isMarkdownEnable = value ?? false;
                    });
                  },
                ),
              if (_isMarkdownEnable && !_isPreviewMode)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: "Bold",
                          onPressed: () => _insertMarkdown('**', '**'),
                          icon: const Icon(Icons.format_bold),
                        ),
                        IconButton(
                          tooltip: "Italic",
                          onPressed: () => _insertMarkdown('*', '*'),
                          icon: const Icon(Icons.format_italic),
                        ),
                        IconButton(
                          tooltip: "List",
                          onPressed: () => _insertMarkdown('- '),
                          icon: const Icon(Icons.format_list_bulleted),
                        ),
                        IconButton(
                          tooltip: "Heading 1",
                          onPressed: () => _insertMarkdown('# '),
                          icon: const Icon(Icons.title),
                        ),
                        IconButton(
                          tooltip: "Code",
                          onPressed: () => _insertMarkdown('```\n', '\n```'),
                          icon: const Icon(Icons.code),
                        ),
                        IconButton(
                          tooltip: "Strikethrough",
                          onPressed: () => _insertMarkdown('~~', '~~'),
                          icon: const Icon(Icons.format_strikethrough),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: _isPreviewMode
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.topLeft,

                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: MarkdownBody(
                            data: _contentController.text.isEmpty
                                ? '_لا يوجد نص للمعاينة_'
                                : _contentController.text,
                            selectable: true,
                          ),
                        ),
                      )
                    : TextField(
                        controller: _contentController,
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: "write your note here",
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
