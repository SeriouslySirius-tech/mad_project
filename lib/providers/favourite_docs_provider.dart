import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'files.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';

class FavouriteDocsNotifier extends StateNotifier<List<FileObject>> {
  FavouriteDocsNotifier() : super([]) {
    initState();
  }

  void initState() async {
    final directoryPath = await getApplicationDocumentsDirectory();
    const favourtiesDirectory = 'favourite_files';
    final fDirectory = Directory('${directoryPath.path}/$favourtiesDirectory');

    state = [];

    await for (var entity
        in fDirectory.list(recursive: false, followLinks: false)) {
      // print(entity.path);
      if (entity is File) {
        FileObject f = FileObject(
          fileName: entity.uri.pathSegments.last,
          filePath: entity.path,
          date: formatter.format(FileStat.statSync(entity.path).modified),
        );
        state = [...state, f];
      }
    }
  }

  bool isFavourite(FileObject file) {
    final exists = state.map((item) => item.filePath).contains(file.filePath);
    return exists;
  }

  Future<bool> toggleFavourite(FileObject file) async {
    final exists = state.map((item) => item.filePath).contains(file.filePath);

    if (exists) {
      List<String> segments = [...File(file.filePath).uri.pathSegments];
      segments[segments.length - 2] = 'normal_files';
      final newPath = segments.join('/');
      File newFile = await File(file.filePath).copy(newPath);
      await File(file.filePath).delete();
      state = state.where((f) => f.filePath != file.filePath).toList();
      file.filePath = newPath;
      return false;
    } else {
      List<String> segments = [...File(file.filePath).uri.pathSegments];
      segments[segments.length - 2] = 'favourite_files';
      final newPath = segments.join('/');
      File newFile = await File(file.filePath).copy(newPath);
      await File(file.filePath).delete();
      state = [...state, file];
      file.filePath = newPath;
      return true;
    }
  }
}

final favouriteDocsProvider =
    StateNotifierProvider<FavouriteDocsNotifier, List<FileObject>>((ref) {
  return FavouriteDocsNotifier();
});
