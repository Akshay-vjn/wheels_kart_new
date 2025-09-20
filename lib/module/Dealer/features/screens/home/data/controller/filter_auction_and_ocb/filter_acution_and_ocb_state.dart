part of 'filter_acution_and_ocb_cubit.dart';

// _makeAndModelList
@immutable
sealed class FilterAcutionAndOcbState {
  final Map<FilterCategory, List<dynamic>>? filterData;
  final Map<FilterCategory, List<dynamic>>? selectedFilters;
  final FilterCategory? currentFilterCategory;
  final String? selectedSort;

  const FilterAcutionAndOcbState({
    this.filterData,
    this.selectedFilters,
    this.currentFilterCategory,
    this.selectedSort,
  });
}

final class FilterAcutionAndOcbIntializingState
    extends FilterAcutionAndOcbState {}

final class FilterAcutionAndOcbInitial extends FilterAcutionAndOcbState {
  const FilterAcutionAndOcbInitial({
    required super.filterData,
    super.selectedFilters,
    super.currentFilterCategory,
    super.selectedSort,
  });
  FilterAcutionAndOcbInitial copyWith({
    Map<FilterCategory, List<dynamic>>? filterData,
    Map<FilterCategory, List<dynamic>>? selectedFilters,
    FilterCategory? currentFilterCategory,
    String? selectedSort,
  }) {
    return FilterAcutionAndOcbInitial(
      selectedSort:selectedSort??this.selectedSort,
      filterData: filterData ?? this.filterData,
      currentFilterCategory:
          currentFilterCategory ?? this.currentFilterCategory,
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }
}
