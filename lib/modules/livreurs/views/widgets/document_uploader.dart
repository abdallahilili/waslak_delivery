import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentUploader extends StatefulWidget {
  final String label;
  final String? initialUrl;
  final Function(File?) onFileChanged;
  final Color? color;

  const DocumentUploader({
    super.key,
    required this.label,
    this.initialUrl,
    required this.onFileChanged,
    this.color,
  });

  @override
  State<DocumentUploader> createState() => _DocumentUploaderState();
}

class _DocumentUploaderState extends State<DocumentUploader> {
  File? _file;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        _file = File(image.path);
      });
      widget.onFileChanged(_file);
    }
  }

  void _removeFile() {
    setState(() {
      _file = null;
    });
    widget.onFileChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
            ),
            child: _file != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_file!, height: 120, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: _removeFile,
                          child: const CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 12,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                : (widget.initialUrl != null && widget.initialUrl!.isNotEmpty
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(widget.initialUrl!, height: 120, width: double.infinity, fit: BoxFit.cover),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(child: Icon(Icons.edit, color: Colors.white, size: 30)),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, color: widget.color ?? Colors.blue, size: 30),
                          const SizedBox(height: 8),
                          Text('Cliquez pour choisir', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                          Text('(JPG, PNG)', style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
                        ],
                      )),
          ),
        ),
      ],
    );
  }
}
