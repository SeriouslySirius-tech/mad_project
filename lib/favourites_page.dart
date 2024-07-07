import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/recent_files.dart';

class FavouritesPage extends ConsumerStatefulWidget {
  const FavouritesPage({super.key, required this.files});
  final List<FileObject> files;

  @override
  ConsumerState<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends ConsumerState<FavouritesPage> {
  // String formattedDate(DateTime date){
  @override
  Widget build(BuildContext context) {
    // final List<FileObject> files = ref.watch(favouriteDocsProvider);
    if (widget.files.isEmpty) {
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
        itemCount: widget.files.length,
        itemBuilder: (context, index) {
          return RecentFiles(
            file: widget.files[index],
          );
        },
      ),
    );
  }
}
