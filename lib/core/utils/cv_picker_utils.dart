import 'dart:io';

import 'package:file_picker/file_picker.dart' as fp;




class PickedCvFile {
  final String fileName;
  final int sizeBytes;
  final File? file;
  final List<int>? bytes;

  const PickedCvFile({
    required this.fileName,
    required this.sizeBytes,
    this.file,
    this.bytes,
  });
}

Future<PickedCvFile?> pickCvFile() async {
  final result = await fp.FilePicker.pickFiles(


    type: fp.FileType.custom,
    allowedExtensions: const ['pdf', 'doc', 'docx'],
    allowMultiple: false,
    withData: true,
  );


  if (result == null || result.files.isEmpty) return null;

  final f = result.files.first;
  final fileName = f.name;
  final sizeBytes = f.size;
  final bytes = f.bytes;
  return PickedCvFile(
    fileName: fileName,
    sizeBytes: sizeBytes,
    file: f.path != null ? File(f.path!) : null,
    bytes: bytes,
  );
}

