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

  int countDoc(String filename) {
    final Map map = {};
    final files = [...state];
    files
        .map((item) => item.fileName.substring(
            0,
            (item.fileName.lastIndexOf('(') < item.fileName.lastIndexOf('.') &&
                    item.fileName.lastIndexOf('(') != -1)
                ? item.fileName.lastIndexOf('(')
                : item.fileName.lastIndexOf('.')))
        .forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] += 1;
      }
    });
    return map[filename] ?? 0;
  }

  void initState() async {
    final directoryPath = await getApplicationDocumentsDirectory();
    // final newDirectory = Directory('${directoryPath.path}/example_directory');
    const normalDirectory = 'normal_files';
    const favouritesDirectory = 'favourite_files';
    final nDirectory = Directory('${directoryPath.path}/$normalDirectory');
    final fDirectory = Directory('${directoryPath.path}/$favouritesDirectory');

    state = [];

    if (!await nDirectory.exists()) {
      await nDirectory.create(recursive: true);
    }
    if (!await fDirectory.exists()) {
      await fDirectory.create(recursive: true);
    }

    await for (var entity
        in nDirectory.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        // print(entity.path);
        FileObject f = FileObject(
          fileName: entity.uri.pathSegments.last,
          filePath: entity.path,
          date: formatter.format(FileStat.statSync(entity.path).modified),
        );
        state = [f, ...state];
      }
    }
    // print("-----");
    await for (var entity
        in fDirectory.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        // print(entity.path);
        FileObject f = FileObject(
          fileName: entity.uri.pathSegments.last,
          filePath: entity.path,
          date: formatter.format(FileStat.statSync(entity.path).modified),
        );
        state = [f, ...state];
      }
    }
  }

  Future<void> removeDoc(FileObject file) async {
    File f = File(file.filePath);
    state =
        state.where((element) => element.filePath != file.filePath).toList();
    await f.delete(recursive: true);
  }

  Future<void> insertDoc(
      int index, FileObject file, PdfDocument contents) async {
    state = [...state]..insert(index, file);
    File f = File(file.filePath);
    final PdfDocument document = contents;

    await f.writeAsBytes(await document.save());
    document.dispose();
  }

  Future<void> addDoc(FileObject f) async {
    state = [f, ...state];
  }

  Future<void> writeDoc({textString, fileName}) async {
    final directoryPath = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${directoryPath.path}/normal_files');
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

    // page.graphics.drawLine(
    //     PdfPen(PdfColor(0, 0, 0)),
    //     Offset(0, layoutResult.bounds.bottom + 15),
    //     Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));

    f.writeAsBytes(await document.save());

    final object = FileObject(
        fileName: f.uri.pathSegments.last,
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
