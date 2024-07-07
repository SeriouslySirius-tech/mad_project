import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';

class FavouriteDocsNotifier extends StateNotifier<List<FileObject>> {
  FavouriteDocsNotifier() : super([]);

  bool isFavourite(FileObject file) {
    final exists = state.contains(file);
    return exists;
  }

  bool toggleFavourite(FileObject file) {
    final exists = state.contains(file);
    if (exists) {
      state = state.where((f) => f.fileName != file.fileName).toList();
      return false;
    } else {
      state = [...state, file];
      return true;
    }
  }
}

final favouriteDocsProvider =
    StateNotifierProvider<FavouriteDocsNotifier, List<FileObject>>((ref) {
  return FavouriteDocsNotifier();
});
