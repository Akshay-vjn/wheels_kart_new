part of 'filter_acution_and_ocb_cubit.dart';

@immutable
sealed class FilterAcutionAndOcbState {
  final Map<String, List<String>>? filterData;
  final Map<String, List<String>>? selectedFilters;
  final String? currentFilterCategory;

  const FilterAcutionAndOcbState({
    this.filterData,
    this.selectedFilters,
    this.currentFilterCategory,
  });
}

final class FilterAcutionAndOcbInitial extends FilterAcutionAndOcbState {
  const FilterAcutionAndOcbInitial({
    required super.filterData,
    super.selectedFilters,
    super.currentFilterCategory,
  });
  FilterAcutionAndOcbInitial copyWith({
    Map<String, List<String>>? filterData,
    Map<String, List<String>>? selectedFilters,
    String? currentFilterCategory,
  }) {
    return FilterAcutionAndOcbInitial(
      filterData: filterData ?? this.filterData,
      currentFilterCategory:
          currentFilterCategory ?? this.currentFilterCategory,
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }
}

final class FilterAcutionAndOcbIntializingState
    extends FilterAcutionAndOcbState {}
