import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mad_project/models/file_object.dart';
import 'dart:io';
import 'dart:async';
import 'package:syncfusion_flutter_pdf/pdf.dart';

const apiKey = "---";

class Model {
  final FileObject? file;
  final List<FileObject>? fileList;
  Model({this.file, this.fileList});

  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  Future<String> generateSummaryforText() async {
    final prompt = TextPart(
        'Can you summarise this given file and what it says? Be as informative and specific with your summaries as possible. The response should be in plaintext only. Do not add any asteriks around any word or sentence');

    final pdfFile = File(file!.filePath);

    final PdfDocument document =
        PdfDocument(inputBytes: pdfFile.readAsBytesSync());

    final TextPart text = TextPart(PdfTextExtractor(document).extractText());

    final content = Content.multi([prompt, text]);
    final response = await model.generateContent([content]);
    return response.text!;
  }

  Future<String> generateSummaryforImages() async {
    final prompt = TextPart(
        'Can you summarise the text given from this image and summarise and what it says? The summary must also be complete and describe the entire document as a whole. The response should be in plaintext only. Do not add any asteriks around any word or sentence');

    final content = Content.multi([
      prompt,
      DataPart('image/jpeg', File(file!.filePath).readAsBytesSync())
    ]);
    final response = await model.generateContent([content]);
    return response.text!;
    // return (await model.generateContent([content])).text;
  }

  Future<String> generateSummaryforImageList() async {
    final prompt = TextPart(
        'Can you identify the topic being written about in the text present in this image? Be as informative and specific with your summaries as possible. The response should be in plaintext only. Do not add any asteriks around any word or sentence');

    List<DataPart> imagels = [];
    for (var f in fileList!) {
      imagels.add(DataPart('image/jpeg', File(f.filePath).readAsBytesSync()));
    }

    final content = Content.multi([prompt, ...imagels]);
    final response = await model.generateContent([content]);
    return response.text!;
  }
}
