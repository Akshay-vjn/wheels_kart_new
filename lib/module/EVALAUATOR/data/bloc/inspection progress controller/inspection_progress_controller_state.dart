class InspectionProgressState {
  final bool isQuestionsCompleted;
  final bool isLegalsCompleted;
  final bool isPhotosCompleted;
  final bool isVideosCompleted;

  const InspectionProgressState({
    this.isQuestionsCompleted = false,
    this.isLegalsCompleted = false,
    this.isPhotosCompleted = false,
    this.isVideosCompleted = false,
  });

  bool get isAllCompleted =>
      isQuestionsCompleted &&
      isLegalsCompleted &&
      isPhotosCompleted &&
      isVideosCompleted;

  bool get isVideoOnlyPending =>
      isQuestionsCompleted && isLegalsCompleted && isPhotosCompleted;

  double get progress {
    int count = 0;
    if (isQuestionsCompleted) count++;
    if (isLegalsCompleted) count++;
    if (isPhotosCompleted) count++;
    if (isVideosCompleted) count++;
    return count / 4;
  }

  InspectionProgressState copyWith({
    bool? isQuestionsCompleted,
    bool? isLegalsCompleted,
    bool? isPhotosCompleted,
    bool? isVideosCompleted,
  }) {
    return InspectionProgressState(
      isQuestionsCompleted: isQuestionsCompleted ?? this.isQuestionsCompleted,
      isLegalsCompleted: isLegalsCompleted ?? this.isLegalsCompleted,
      isPhotosCompleted: isPhotosCompleted ?? this.isPhotosCompleted,
      isVideosCompleted: isVideosCompleted ?? this.isVideosCompleted,
    );
  }
}