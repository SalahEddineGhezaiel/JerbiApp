import 'package:flutter/material.dart';

class SearchFilterSection extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onFilter;

  const SearchFilterSection({
    super.key,
    required this.onSearch,
    required this.onFilter,
  });

  @override
  State<SearchFilterSection> createState() => _SearchFilterSectionState();
}

class _SearchFilterSectionState extends State<SearchFilterSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          // Filter Button
          Material(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: widget.onFilter,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE9ECEF),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: Color(0xFF6C757D),
                  size: 20,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Search Bar
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE9ECEF),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearch,
                style: const TextStyle(
                  fontFamily: 'SFPro',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF212529),
                ),
                decoration: InputDecoration(
                  hintText: 'Rechercher',
                  hintStyle: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6C757D).withValues(alpha: 0.7),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16, right: 12),
                    child: Icon(
                      Icons.search,
                      color: Color(0xFF6C757D),
                      size: 20,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0xFF6C757D),
                            size: 20,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearch('');
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                    left: 0,
                    right: 16,
                    top: 14,
                    bottom: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}