class DurationState {
  final Duration progress;
  final Duration buffered;
  final Duration total;
  const DurationState({required this.progress, required this.buffered, this.total=Duration.zero});

}
