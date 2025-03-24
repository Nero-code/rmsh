import 'package:flutter/material.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({
    super.key,
    required this.onPositive,
    required this.currentLang,
  });

  final void Function(String) onPositive;
  final String currentLang;

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  String lang = '';
  @override
  void initState() {
    lang = widget.currentLang;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.language),
      title: const Text("choose lang"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text("English"),
            value: 'en',
            groupValue: lang,
            onChanged: (value) {
              if (value != null) setState(() => lang = value);
            },
          ),
          RadioListTile(
            title: const Text("العربية"),
            value: 'ar',
            groupValue: lang,
            onChanged: (value) {
              if (value != null) setState(() => lang = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onPositive(lang);
            Navigator.pop(context);
          },
          child: Text("ok"),
        ),
      ],
    );
  }
}
