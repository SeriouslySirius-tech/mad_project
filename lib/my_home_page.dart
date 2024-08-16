import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/providers/files.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/recent_files.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.files});
  final List<FileObject> files;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String? deletedFilePath;
  late String contents;

  @override
  Widget build(BuildContext context) {
    final files = ref.watch(filesProvider);
    PdfDocument? pdfDocument;
    if (files.isEmpty) {
      return Center(
          child: Text(
        "Add some files here!",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ));
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(files[index].fileName),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                final deletedDoc = files[index];
                setState(() {
                  deletedFilePath = deletedDoc.filePath;
                  File f = File(deletedFilePath!);
                  //Load an existing PDF document.
                  pdfDocument = PdfDocument(inputBytes: f.readAsBytesSync());
                  // contents = PdfTextExtractor(document).extractText();
                  // print(contents);
                  ref.read(filesProvider.notifier).removeDoc(deletedDoc);
                });
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Doc has been deleted'),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        setState(() {
                          ref
                              .read(filesProvider.notifier)
                              .insertDoc(index, deletedDoc, pdfDocument!);
                        });
                      },
                    )));
              }
            },
            child: RecentFiles(
              file: files[index],
            ),
          );
        },
      ),
    );
  }
}
