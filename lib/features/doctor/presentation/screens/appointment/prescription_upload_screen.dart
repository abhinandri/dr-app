
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:dr_app/core/services/cloudinary_service.dart';

class PrescriptionUploadScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const PrescriptionUploadScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<PrescriptionUploadScreen> createState() =>
      _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState
    extends State<PrescriptionUploadScreen> {
  final _notesController = TextEditingController();

  PlatformFile? _selectedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty && mounted) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _savePrescription() async {
    final file = _selectedFile;
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    final appointmentId = widget.appointment['id']?.toString();
    final patientId = widget.appointment['userId']?.toString();

    if (file == null ||
        doctorId == null ||
        appointmentId == null ||
        patientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing file or appointment information'),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final fileUrl = await CloudinaryService.uploadPrescription(file);

      if (fileUrl == null) {
        throw Exception('File upload failed');
      }

      await FirebaseFirestore.instance.collection('prescriptions').add({
        'appointmentId': appointmentId,
        'patientId': patientId,
        'doctorId': doctorId,
        'notes': _notesController.text.trim(),
        'fileUrl': fileUrl,
        'fileName': file.name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prescription uploaded successfully'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save prescription: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Prescription')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Patient: ${widget.appointment['userName'] ?? 'Patient'}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Prescription notes',
              hintText: 'Enter instructions for the patient',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _isUploading ? null : _pickFile,
            icon: const Icon(Icons.attach_file),
            label: Text(
              _selectedFile?.name ?? 'Select PDF or image',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isUploading ? null : _savePrescription,
            child: _isUploading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Upload Prescription'),
          ),
        ],
      ),
    );
  }
}
