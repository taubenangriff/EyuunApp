import 'dart:io';

import 'package:file_tree_view/file_tree_view.dart';
import 'package:file_tree_view/style.dart';
import 'package:flutter/material.dart';

class SelectFileWidget extends StatelessWidget {

  final void Function(File file)? onFileSelected;

  const SelectFileWidget({
    super.key,
    this.onFileSelected
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DirectoryTreeViewer(
        rootPath: 'D:\\Coding\\flexbackend\\editor\\assetdata',
        onFileTap: (file, tap) {
          onFileSelected?.call(file);
        },
        fileActions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.delete))
        ],
        enableCreateFileOption: true,
        enableCreateFolderOption: true,
        editingFieldStyle: EditingFieldStyle(
          textStyle: const TextStyle(color: Colors.grey),
          cursorColor: Colors.grey,
          cursorHeight: 18,
          verticalTextAlign: TextAlignVertical.top,
          textfieldDecoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          folderIcon: const Icon(
            Icons.folder,
            color: Colors.grey,
            size: 20,
          ),
          fileIcon: const Icon(
            Icons.edit_document,
            color: Colors.grey,
            size: 20,
          ),
          doneIcon: const Icon(
            Icons.check,
            color: Colors.grey,
            size: 20,
          ),
          cancelIcon: const Icon(
            Icons.close,
            color: Colors.grey,
            size: 20,
          ),
        ),
        fileStyle: FileStyle(
          fileNameStyle: TextStyle(color: Colors.grey[400]),
        ),
        fileIconBuilder: (extension) => Icon(Icons.add),
      )
    );
  }
}