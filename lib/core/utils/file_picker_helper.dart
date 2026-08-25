import 'package:file_picker/file_picker.dart';

Future<PlatformFile?> pickCertificate() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
  );

  if (result == null) return null;
  return result.files.first;
}
