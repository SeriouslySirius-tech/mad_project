import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/file_display.dart';
import 'package:mad_project/models/file_object.dart';
import 'package:mad_project/providers/favourite_docs_provider.dart';
import 'dart:io';
import 'package:mad_project/providers/files.dart';

class RecentFiles extends ConsumerWidget {
  final FileObject file;

  const RecentFiles({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        try {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => FileDisplayWidget(file: File(file.filePath))));
        } catch (error) {
          // Handle error (e.g., display a snackbar)
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error opening file")));
        }
      },
      child: ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: Text(
            file.fileName,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "Created on ${file.date}",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () {
              ref.read(favouriteDocsProvider.notifier).toggleFavourite(file);
            },
            icon: ref.read(favouriteDocsProvider.notifier).isFavourite(file)
                ? Icon(
                    Icons.favorite,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )
                : const Icon(Icons.favorite_outline),
          )),
    );
  }
}
