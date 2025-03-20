import 'package:flutter/material.dart';

class BasicDialog extends StatelessWidget {
  const BasicDialog({
    super.key,
    this.title,
    this.content,
    this.action,
    this.icon,
  });

  final String? title;
  final String? content;
  final Widget? icon;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon,
      title:
          title != null ? Text(title!, textDirection: TextDirection.rtl) : null,
      content: content != null
          ? Text(content!, textDirection: TextDirection.rtl)
          : null,
      actions: [
        ElevatedButton(
          onPressed: () {
            if (action != null) action!();
            Navigator.pop(context);
          },
          child: const Text('حسنا'),
        ),
      ],
    );
  }
}
