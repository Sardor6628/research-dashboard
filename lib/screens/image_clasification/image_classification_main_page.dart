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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(),
          SizedBox(height: 20),
          _buildImageUploadButton(),
          if (_selectedImage != null) _buildSelectedImageInfo(),
          SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<ImageAnalysisCubit, ImageAnalysisState>(
              builder: (context, state) {
                if (state is ImageAnalysisLoading) {
                  return _buildLoadingIndicator();
                } else if (state is ImageAnalysisLoaded) {
                  return _buildAnalysisUI(state.result);
                } else if (state is ImageAnalysisError) {
                  return _buildErrorUI(state.message);
                } else {
                  return _buildPlaceholderText();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Header Title
  Widget _buildHeader() {
    return Text(
      "Image Classification",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
    );
  }

  /// Image Upload Button with Material 3 Styling
  Widget _buildImageUploadButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      onPressed: _pickImage,
      icon: Icon(Icons.upload, color: Colors.white),
      label: Text("Select an Image", style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  /// Selected Image Display
  Widget _buildSelectedImageInfo() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        "Selected File: ${_selectedImage!.name}",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
    );
  }

  /// Loading Indicator
  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: Colors.blueAccent),
        SizedBox(height: 10),
        Text("Analyzing Image...", style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
      ],
    );
  }

  /// Placeholder Text Before Upload
  Widget _buildPlaceholderText() {
    return Text(
      "Upload an image to analyze.",
      style: TextStyle(fontSize: 16, color: Colors.grey),
    );
  }

  /// Error Display UI
  Widget _buildErrorUI(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
          SizedBox(height: 10),
          Text(errorMessage, style: TextStyle(fontSize: 16, color: Colors.redAccent)),
        ],
      ),
    );
  }

  /// Analysis Results UI
  Widget _buildAnalysisUI(ImageAnalysisResult result) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(16),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Analysis Results", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blueAccent)),
              Divider(thickness: 1),
              SizedBox(height: 10),

              /// Angles Data
              Text("Angles:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ...result.angles.entries.map((entry) => Text("${entry.key}: ${entry.value.toStringAsFixed(1)}°", style: TextStyle(fontSize: 14))),
              SizedBox(height: 10),

              /// Landmarks Data
              Text("Landmarks:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ...result.landmarks.entries.map((entry) {
                return Text("${entry.key}: x=${entry.value['x']}, y=${entry.value['y']}, z=${entry.value['z']}", style: TextStyle(fontSize: 14));
              }),

              SizedBox(height: 10),

              /// Annotated Image Display
              Text("Annotated Image:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  result.annotatedImageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Text("Failed to load image.", style: TextStyle(color: Colors.redAccent));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}