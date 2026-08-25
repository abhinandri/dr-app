class AvailabilityState {
  final bool isLoading;
  final Map<String, List<String>> availability;

  const AvailabilityState({
    this.isLoading = false,
    this.availability = const {},
  });

  AvailabilityState copyWith({
    bool? isLoading,
    Map<String, List<String>>? availability,
  }) {
    return AvailabilityState(
      isLoading: isLoading ?? this.isLoading,
      availability: availability ?? this.availability,
    );
  }
}