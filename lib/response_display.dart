// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mad_project/providers/files.dart';

// import 'package:flutter_markdown/flutter_markdown.dart';
// ignore: must_be_immutable
class ResponseDisplay extends ConsumerStatefulWidget {
  final String textString;
  const ResponseDisplay({super.key, required this.textString});

  @override
  ConsumerState<ResponseDisplay> createState() => _ResponseDisplayState();
}

class _ResponseDisplayState extends ConsumerState<ResponseDisplay> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _showFileNameDialog(BuildContext context) async {
    String? fileName;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter File Name',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer)),
          content: TextField(
            cursorColor: Theme.of(context).colorScheme.onPrimaryContainer,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimaryContainer)),
              labelText: 'File Name',
              labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer)),
              onPressed: () {
                fileName = _controller.text.trim();
                _controller.clear();
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
          contentTextStyle: Theme.of(context).textTheme.headlineMedium,
        );
      },
    );

    if (fileName != null) fileName!.trim();
    int countOfFile = (fileName != null)
        ? ref.read(filesProvider.notifier).countDoc(fileName!)
        : 0;

    if (countOfFile > 0) fileName = '$fileName ($countOfFile)';

    return fileName;
  }

  void writeFile(context, ref) async {
    String? fileName = await _showFileNameDialog(context);
    print(fileName);
    if (fileName == null) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (ctx) => Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.white,
          size: 50,
        ),
      ),
    ));
    ref
        .read(filesProvider.notifier)
        .writeDoc(textString: widget.textString.trim(), fileName: fileName);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Durations.medium1,
        content: Text('File Saved as $fileName.pdf'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final markdownText = MarkdownBody(data: textString);

    return Scaffold(
      appBar: AppBar(title: const Text("Response text")),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          SingleChildScrollView(
            child: Text(
              widget.textString,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 30,
            height: 50,
            child: TextButton(
              onPressed: () => writeFile(context, ref),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text("Save",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: const Color.fromARGB(255, 253, 248, 255),
                      fontSize: 20)),
            ),
          ),
        ]),
      ),
    );
  }
}
