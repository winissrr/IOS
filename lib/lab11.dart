import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String themeKey = 'app_theme_dark_mode';
const String usernameKey = 'user_display_name';
const String notesKey = 'saved_notes';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool(themeKey) ?? false;
  final String username = prefs.getString(usernameKey) ?? 'Guest User';
  final String? savedNotesJson = prefs.getString(notesKey);
  List<NoteItem> initialNotes = [];

  if (savedNotesJson != null && savedNotesJson.isNotEmpty) {
    try {
      final List<dynamic> decoded = jsonDecode(savedNotesJson) as List<dynamic>;
      initialNotes = decoded
          .map(
            (item) => NoteItem.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (error) {
      initialNotes = [];
    }
  }

  runApp(
    NotesVaultApp(
      prefs: prefs,
      initialDarkMode: isDarkMode,
      initialUsername: username,
      initialNotes: initialNotes,
    ),
  );
}

class NoteItem {
  final String id;
  final String title;
  final String dateText;
  final bool isCompleted;

  const NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateText': dateText,
      'isCompleted': isCompleted,
    };
  }

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id: json['id'] as String,
      title: json['title'] as String,
      dateText: json['dateText'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  NoteItem copyWith({bool? isCompleted}) {
    return NoteItem(
      id: id,
      title: title,
      dateText: dateText,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class NotesVaultApp extends StatefulWidget {
  final SharedPreferences prefs;
  final bool initialDarkMode;
  final String initialUsername;
  final List<NoteItem> initialNotes;

  const NotesVaultApp({
    super.key,
    required this.prefs,
    required this.initialDarkMode,
    required this.initialUsername,
    required this.initialNotes,
  });

  @override
  State<NotesVaultApp> createState() => _NotesVaultAppState();
}

class _NotesVaultAppState extends State<NotesVaultApp> {
  late bool isDarkMode;
  late String username;
  late List<NoteItem> notes;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.initialDarkMode;
    username = widget.initialUsername;
    notes = List<NoteItem>.from(widget.initialNotes);
  }

  Future<void> toggleTheme(bool value) async {
    setState(() {
      isDarkMode = value;
    });

    await widget.prefs.setBool(themeKey, value);
  }

  Future<void> saveUsername(String value) async {
    final String cleanedName = value.trim();

    if (cleanedName.isEmpty) {
      _showMessage('Please enter your name.');
      return;
    }

    await widget.prefs.setString(usernameKey, cleanedName);

    setState(() {
      username = cleanedName;
    });

    FocusScope.of(context).unfocus();
    _showMessage('Username saved successfully!');
  }

  Future<void> saveNotes() async {
    final String encodedNotes = jsonEncode(
      notes.map((note) => note.toJson()).toList(),
    );

    await widget.prefs.setString(notesKey, encodedNotes);
  }

  Future<void> addNote(String title) async {
    final String cleanedTitle = title.trim();

    if (cleanedTitle.isEmpty) {
      _showMessage('Please enter a note title.');
      return;
    }

    final DateTime now = DateTime.now();
    final String dateText =
        '${now.day.toString().padLeft(2, '0')}.'
        '${now.month.toString().padLeft(2, '0')}.'
        '${now.year}';

    final NoteItem newNote = NoteItem(
      id: now.microsecondsSinceEpoch.toString(),
      title: cleanedTitle,
      dateText: dateText,
      isCompleted: false,
    );

    setState(() {
      notes.insert(0, newNote);
    });

    await saveNotes();
    _showMessage('Note added!');
  }

  Future<void> toggleNote(String id, bool isCompleted) async {
    setState(() {
      notes = notes.map((note) {
        if (note.id == id) {
          return note.copyWith(isCompleted: isCompleted);
        }
        return note;
      }).toList();
    });

    await saveNotes();
  }

  Future<void> deleteNote(String id) async {
    setState(() {
      notes.removeWhere((note) => note.id == id);
    });

    await saveNotes();
    _showMessage('Note deleted.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: const AppBarTheme(centerTitle: false),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
      ),
      home: NotesHomePage(
        username: username,
        isDarkMode: isDarkMode,
        notes: notes,
        onThemeChanged: toggleTheme,
        onSaveUsername: saveUsername,
        onAddNote: addNote,
        onToggleNote: toggleNote,
        onDeleteNote: deleteNote,
      ),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  final String username;
  final bool isDarkMode;
  final List<NoteItem> notes;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<String> onSaveUsername;
  final ValueChanged<String> onAddNote;
  final void Function(String id, bool value) onToggleNote;
  final ValueChanged<String> onDeleteNote;

  const NotesHomePage({
    super.key,
    required this.username,
    required this.isDarkMode,
    required this.notes,
    required this.onThemeChanged,
    required this.onSaveUsername,
    required this.onAddNote,
    required this.onToggleNote,
    required this.onDeleteNote,
  });

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  late final TextEditingController nameController;
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.username);
  }

  @override
  void didUpdateWidget(covariant NotesHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.username != widget.username) {
      nameController.text = widget.username;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final int completedCount =
        widget.notes.where((note) => note.isCompleted).length;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.edit_note_rounded),
            SizedBox(width: 8),
            Text('Notes Vault', style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
        actions: [
          Icon(
            widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            size: 20,
          ),
          Switch(value: widget.isDarkMode, onChanged: widget.onThemeChanged,),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Hello, ${widget.username}!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold,),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your personal space for ideas and tasks.',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.person_outline),
                            SizedBox(width: 8),
                            Text(
                              'User profile',
                              style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: nameController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Your username',
                            hintText: 'Enter your name',
                            prefixIcon: Icon(Icons.badge_outlined),
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: widget.onSaveUsername,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: () =>
                                widget.onSaveUsername(nameController.text),
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Save name'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.add_circle_outline),
                            SizedBox(width: 8),
                            Text(
                              'Create a new note',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: noteController,
                          textInputAction: TextInputAction.done,
                          maxLength: 100,
                          decoration: const InputDecoration(
                            labelText: 'Note title',
                            hintText: 'What do you need to remember?',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          onSubmitted: (value) {
                            widget.onAddNote(value);
                            noteController.clear();
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              if (noteController.text.trim().isNotEmpty) {
                                widget.onAddNote(noteController.text);
                                noteController.clear();
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add note'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Notes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,),
                    ),
                    Text(
                      '$completedCount / ${widget.notes.length} completed',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (widget.notes.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 18,),
                      child: Column(
                        children: [
                          Icon(
                            Icons.sticky_note_2_outlined,
                            size: 48,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'No notes yet',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add your first note above.',
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...widget.notes.map(
                    (note) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4, ),
                        leading: Checkbox(
                          value: note.isCompleted,
                          onChanged: (value) {
                            widget.onToggleNote(note.id, value ?? false);
                          },
                        ),
                        title: Text(
                          note.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: note.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: note.isCompleted
                                ? colors.onSurfaceVariant
                                : colors.onSurface,
                          ),
                        ),
                        subtitle: Text('Created: ${note.dateText}'),
                        trailing: IconButton(
                          tooltip: 'Delete note',
                          onPressed: () => widget.onDeleteNote(note.id),
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent,),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Your notes are stored locally on this device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
