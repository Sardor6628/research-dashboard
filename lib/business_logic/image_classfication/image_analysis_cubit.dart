import 'dart:html' as html;
import 'package:admin/models/image_analysis_model.dart';
import 'package:admin/repositories/image_analysis_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_analysis_state.dart';

class ImageAnalysisCubit extends Cubit<ImageAnalysisState> {
  final ImageAnalysisRepository repository;

  ImageAnalysisCubit(this.repository) : super(ImageAnalysisInitial());

  Future<void> analyzeImage(html.File image) async {
    try {
      emit(ImageAnalysisLoading());
      final result = await repository.analyzeImage(image);
      if (result != null) {
        emit(ImageAnalysisLoaded(result));
      } else {
        emit(ImageAnalysisError("Failed to analyze image"));
      }
    } catch (e) {
      emit(ImageAnalysisError("Error: $e"));
    }
  }
}