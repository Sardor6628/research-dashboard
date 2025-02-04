class ImageAnalysisResult {
  final Map<String, double> angles;
  final Map<String, Map<String, double>> landmarks;
  final String annotatedImageUrl;

  ImageAnalysisResult({
    required this.angles,
    required this.landmarks,
    required this.annotatedImageUrl,
  });

  factory ImageAnalysisResult.fromJson(Map<String, dynamic> json) {
    return ImageAnalysisResult(
      angles: Map<String, double>.from(json['angles']),
      landmarks: (json['landmarks'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(key, Map<String, double>.from(value));
      }),
      annotatedImageUrl: json['annotated_image_url'],
    );
  }
}