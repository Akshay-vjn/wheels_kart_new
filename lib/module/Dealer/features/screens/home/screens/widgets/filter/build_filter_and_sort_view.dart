import 'package:flutter/material.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/filter/build_filter_sheet.dart';

class FilterAndSortWidget extends StatefulWidget {
  
  final Function(Map<String, dynamic>)? onFiltersApplied;
  final Function(String)? onSortApplied;

  const FilterAndSortWidget({
    Key? key,
    this.onFiltersApplied,
    this.onSortApplied,
  }) : super(key: key);

  @override
  _FilterAndSortWidgetState createState() => _FilterAndSortWidgetState();
}

class _FilterAndSortWidgetState extends State<FilterAndSortWidget> {
  String selectedSort = "Relevance (Default)";
  Map<String, dynamic> appliedFilters = {};

  double w(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w(context),
      color: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildActionButton("Filters", Icons.filter_alt_outlined, () {
              _showFilterBottomSheet();
            }),
            _buildActionButton("Sort", Icons.sort, () {
              _showSortBottomSheet();
            }),
            // _buildActionButton("Spinny Prime", Icons.star_outline, () {}),
            // _buildActionButton(
            //   "No Transit Cost",
            //   Icons.local_shipping_outlined,
            //   () {},
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    void Function()? onTap,
  ) => InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 0.8),
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade50,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    ),
  );

  void _showSortBottomSheet() {
    List<String> sortOptions = [
      "Relevance (Default)",
      "Newest First",
      "Ending Soonest",
      "Price - Low to High",
      "Price - High to Low",
      "Year - Old to New",
      "Year - New to Old",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sort by",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              // Sort Options
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortOptions.length,
                  itemBuilder: (context, index) {
                    String option = sortOptions[index];
                    bool isSelected = selectedSort == option;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedSort = option;
                        });
                        widget.onSortApplied?.call(option);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade400,
                                  width: 2,
                                ),
                                color:
                                    isSelected
                                        ? Colors.blue
                                        : Colors.transparent,
                              ),
                              child:
                                  isSelected
                                      ? Center(
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                      : null,
                            ),
                            SizedBox(width: 15),
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    isSelected
                                        ? Colors.black
                                        : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FilterBottomSheet(

          onFiltersApplied: (filters) {
            setState(() {
              appliedFilters = filters;
            });
            widget.onFiltersApplied?.call(filters);
          },
          initialFilters: appliedFilters,
        );
      },
    );
  }
}
