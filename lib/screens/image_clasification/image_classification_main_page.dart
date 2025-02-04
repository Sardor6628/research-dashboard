import 'dart:html' as html;
import 'package:admin/business_logic/image_classfication/image_analysis_cubit.dart';
import 'package:admin/models/image_analysis_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ImageClassificationMainPage extends StatefulWidget {
  @override
  _ImageClassificationMainPageState createState() => _ImageClassificationMainPageState();
}

class _ImageClassificationMainPageState extends State<ImageClassificationMainPage> {
  html.File? _selectedImage;

  Future<void> _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files.first;
        setState(() {
          _selectedImage = file;
        });

        context.read<ImageAnalysisCubit>().analyzeImage(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text("Select Image"),
          ),
        ),
        if (_selectedImage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Selected File: ${_selectedImage!.name}"),
          ),
        Expanded(
          child: BlocBuilder<ImageAnalysisCubit, ImageAnalysisState>(
            builder: (context, state) {
              if (state is ImageAnalysisLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ImageAnalysisLoaded) {
                return _buildAnalysisUI(state.result);
              } else if (state is ImageAnalysisError) {
                return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
              } else {
                return Center(child: Text("Select an image to analyze."));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisUI(ImageAnalysisResult result) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Analysis Results", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 10),
              Text("Angles:"),
              ...result.angles.entries.map((entry) => Text("${entry.key}: ${entry.value.toStringAsFixed(1)}°")),
              SizedBox(height: 10),
              Text("Landmarks:"),
              ...result.landmarks.entries.map((entry) {
                return Text("${entry.key}: x=${entry.value['x']}, y=${entry.value['y']}, z=${entry.value['z']}");
              }),
              SizedBox(height: 10),
              Text("Annotated Image:", style: TextStyle(fontWeight: FontWeight.bold)),
              Image.network(result.annotatedImageUrl, height: 200, errorBuilder: (context, error, stackTrace) {
                return Text("Failed to load image.");
              }),
            ],
          ),
        ),
      ),
    );
  }
}