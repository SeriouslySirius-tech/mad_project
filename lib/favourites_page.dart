import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/providers/favourite_docs_provider.dart';
import 'package:mad_project/recent_files.dart';

class FavouritesPage extends ConsumerStatefulWidget {
  const FavouritesPage({super.key, required this.favFiles});
  final List<FileObject> favFiles;

  @override
  ConsumerState<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends ConsumerState<FavouritesPage> {
  // String formattedDate(DateTime date){
  @override
  Widget build(BuildContext context) {
    final favFiles = ref.watch(favouriteDocsProvider);
    if (favFiles.isEmpty) {
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
        itemCount: favFiles.length,
        itemBuilder: (context, index) {
          return RecentFiles(
            file: favFiles[index],
          );
        },
      ),
    );
  }
}
