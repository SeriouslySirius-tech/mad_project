// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
// import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:flutter/material.dart';

final formatter = DateFormat('dd-MM-yy HH:mm');

class FilesNotifier extends StateNotifier<List<FileObject>> {
  FilesNotifier() : super([]) {
    initState();
  }

  void initState() async {
    final directoryPath = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${directoryPath.path}/example_directory');

    state = [];

    // Create the new directory if it does not exist
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }

    // Create some files within the new directory
    for (int i = 1; i <= 3; i++) {
      final f = File('${newDirectory.path}/file_$i.pdf');
      final PdfDocument document = PdfDocument();

      document.pages.add().graphics.drawString(
          'This is file $i', PdfStandardFont(PdfFontFamily.helvetica, 14),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: const Rect.fromLTWH(0, 0, 150, 20));

      // final pdf = pw.Document();
      // pdf.addPage(
      //   pw.Page(
      //     build: (pw.Context context) {
      //       return pw.Text('This is file $i');
      //     },
      //   ),
      // );

      await f.writeAsBytes(await document.save());
      document.dispose();
      // final uniqueFileName = formatter.format(DateTime.now());
    }

    await for (var entity
        in newDirectory.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        FileObject f = FileObject(
          fileName: entity.uri.pathSegments.last,
          filePath: entity.path,
          date: formatter.format(DateTime.now()),
        );
        state = [...state, f];
      }
    }
  }

  Future<void> removeDoc(FileObject file) async {
    File f = File(file.filePath);
    state = state.where((element) => element != file).toList();
    await f.delete(recursive: true);
  }

  Future<void> insertDoc(
      int index, FileObject file, PdfDocument contents) async {
    state = [...state]..insert(index, file);
    File f = File(file.filePath);
    final PdfDocument document = contents;

    // document.pages.add().graphics.drawString(
    //     contents, PdfStandardFont(PdfFontFamily.helvetica, 14),
    //     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    //     bounds: const Rect.fromLTWH(0, 0, 150, 20));

    await f.writeAsBytes(await document.save());
    document.dispose();
  }

  Future<void> addDoc(FileObject f) async {
    state = [f, ...state];
  }

  Future<void> writeDoc({textString, fileName}) async {
    final directoryPath = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${directoryPath.path}/example_directory');
    File f = File('${newDirectory.path}/$fileName.pdf');

    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();

    final PdfLayoutResult layoutResult = PdfTextElement(
            text: textString,
            font: PdfStandardFont(PdfFontFamily.helvetica, 14),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

    page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0)),
        Offset(0, layoutResult.bounds.bottom + 15),
        Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));

    f.writeAsBytes(await document.save());

    final object = FileObject(
        fileName: fileName,
        filePath: f.path,
        date: formatter.format(DateTime.now()));
    await addDoc(object);
    document.dispose();
  }
}

final filesProvider =
    StateNotifierProvider<FilesNotifier, List<FileObject>>((ref) {
  return FilesNotifier();
});
