import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileDisplayWidget extends StatefulWidget {
  final File file; // Path to the file (asset or external storage)

  const FileDisplayWidget({super.key, required this.file});

  @override
  State<FileDisplayWidget> createState() => _FileDisplayWidgetState();
}

class _FileDisplayWidgetState extends State<FileDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    // final PdfViewerController pdfViewerController = PdfViewerController();
    // Uint8List? _pdfBytes;
    // _pdfBytes = File(widget.file.filePath).readAsBytesSync();
    // print(widget.file.path);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.file.uri.pathSegments.last),
          titleTextStyle:
              Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
        ),
        body: SfPdfViewer.file(widget.file),
      ),
    );
  }
}
