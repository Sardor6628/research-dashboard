part of 'image_analysis_cubit.dart';

abstract class ImageAnalysisState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImageAnalysisInitial extends ImageAnalysisState {}

class ImageAnalysisLoading extends ImageAnalysisState {}

class ImageAnalysisLoaded extends ImageAnalysisState {
  final ImageAnalysisResult result;
  ImageAnalysisLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class ImageAnalysisError extends ImageAnalysisState {
  final String message;
  ImageAnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}