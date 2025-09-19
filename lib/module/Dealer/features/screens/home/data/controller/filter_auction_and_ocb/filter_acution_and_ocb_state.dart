part of 'filter_acution_and_ocb_cubit.dart';

// _makeAndModelList
@immutable
sealed class FilterAcutionAndOcbState {
  final Map<FilterCategory, List<dynamic>>? filterData;
  final Map<FilterCategory, List<dynamic>>? selectedFilters;
  final FilterCategory? currentFilterCategory;

  const FilterAcutionAndOcbState({
    this.filterData,
    this.selectedFilters,
    this.currentFilterCategory,
  });
}

final class FilterAcutionAndOcbIntializingState
    extends FilterAcutionAndOcbState {}

final class FilterAcutionAndOcbInitial extends FilterAcutionAndOcbState {
  const FilterAcutionAndOcbInitial({
    required super.filterData,
    super.selectedFilters,
    super.currentFilterCategory,
  });
  FilterAcutionAndOcbInitial copyWith({
    Map<FilterCategory, List<dynamic>>? filterData,
    Map<FilterCategory, List<dynamic>>? selectedFilters,
    FilterCategory? currentFilterCategory,
  }) {
    return FilterAcutionAndOcbInitial(
      filterData: filterData ?? this.filterData,
      currentFilterCategory:
          currentFilterCategory ?? this.currentFilterCategory,
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }
}
