
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dt32inwts';
  static const String uploadPreset = 'doctor_certificates_preset';

  static Future<String?> uploadCertificate(PlatformFile file) async {
    try {
      final uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");

      final request = http.MultipartRequest('POST', uri);

      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'doctor_certificates';

      // ✅ SAFE FOR WEB + MOBILE
      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
          ),
        );
      } else if (file.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path!,
          ),
        );
      } else {
        debugPrint('❌ File has no path and no bytes');
        return null;
      }

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(resBody);
        return data['secure_url'];
      } else {
        debugPrint("❌ Cloudinary upload failed: $resBody");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Cloudinary exception: $e");
      return null;
    }
  }

  static Future<String?> uploadProfileImage(File file) async {
  try {
    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = uploadPreset;
    request.fields['folder'] = 'doctor_profiles';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
      ),
    );

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(resBody);
      return data['secure_url'];
    } else {
      debugPrint("❌ Image upload failed: $resBody");
      return null;
    }
  } catch (e) {
    debugPrint("❌ Image upload exception: $e");
    return null;
  }
}


static Future<String?> uploadPrescription(PlatformFile file) async {
  try {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/raw/upload',
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = uploadPreset;
    request.fields['folder'] = 'prescriptions';

    if (file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file.bytes!,
          filename: file.name,
        ),
      );
    } else if (file.path != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path!,
          filename: file.name,
        ),
      );
    } else {
      return null;
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(responseBody);
      return data['secure_url'] as String?;
    }

    debugPrint('Prescription upload failed: $responseBody');
    return null;
  } catch (e) {
    debugPrint('Prescription upload error: $e');
    return null;
  }
}

}
