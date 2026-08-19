import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AddEditNoteScreen extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final bool? initialIsMarkdown;

  const AddEditNoteScreen({
    super.key,
    this.initialTitle,
    this.initialContent,
    this.initialIsMarkdown,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late bool _isMarkdownEnable;
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController = TextEditingController(
      text: widget.initialContent ?? '',
    );
    _isMarkdownEnable = widget.initialIsMarkdown ?? false;
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

    if (start < 0 || end < 0) {
      _contentController.text = text + prefix + suffix;
      return;
    }
    final selectedText = text.substring(start, end);
    final newText = text.replaceRange(
      start,
      end,
      '$prefix$selectedText$suffix',
    );

    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(
      offset: start + prefix.length + selectedText.length + suffix.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final currentTitle = _titleController.text.trim();
        final currentContent = _contentController.text.trim();
        final initialTitle = widget.initialTitle?.trim() ?? '';
        final initialContent = widget.initialContent?.trim() ?? '';

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
            (widget.initialTitle != null || widget.initialContent != null)
                ? 'Edit Note'
                : 'Add Note',
          ),
          actions: [
            if (_isMarkdownEnable)
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
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Divider(),
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
              if (_isMarkdownEnable)
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
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: _isPreviewMode
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
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