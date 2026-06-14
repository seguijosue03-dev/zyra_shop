import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/home/presentation/widgets/mock_products.dart';
import '../widgets/search_bar_header.dart';
import '../widgets/search_history_section.dart';
import '../widgets/trending_searches_section.dart';
import '../widgets/search_results_grid.dart';
import '../widgets/empty_search_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/sort_bottom_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  
  List<String> _history = [
    'Robe noire',
    'Jean oversize',
    'Hoodie femme',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String term) {
    _searchCtrl.text = term;
    _searchCtrl.selection = TextSelection.fromPosition(TextPosition(offset: term.length));
    if (!_history.contains(term)) {
      setState(() {
        _history.insert(0, term);
      });
    } else {
      setState(() {});
    }
  }

  void _onRemoveHistory(String term) {
    setState(() {
      _history.remove(term);
    });
  }

  void _onClearHistory() {
    setState(() {
      _history.clear();
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.toLowerCase().trim();
    
    // Simple mock reactive filtering
    final filteredProducts = query.isEmpty 
        ? <Product>[]
        : mockProducts.where((p) {
            return p.name.toLowerCase().contains(query) || 
                   p.category.toLowerCase().contains(query);
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SearchBarHeader(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              onClear: () {
                _searchCtrl.clear();
                setState(() {});
              },
              onFilterTap: _showFilterSheet,
            ),
            
            // Content Area
            Expanded(
              child: query.isEmpty
                  ? _buildIdleState()
                  : _buildActiveState(filteredProducts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdleState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchHistorySection(
            history: _history,
            onSearch: _onSearch,
            onRemove: _onRemoveHistory,
            onClearAll: _onClearHistory,
          ),
          const Divider(color: AppColors.border, height: 1),
          TrendingSearchesSection(
            onSearch: _onSearch,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveState(List<Product> products) {
    return Column(
      children: [
        // Sort/Filter sticky bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: _showSortSheet,
                child: Row(
                  children: [
                    const Icon(Icons.swap_vert_rounded, size: 18, color: AppColors.textPrimary),
                    const SizedBox(width: 6),
                    Text(
                      'Trier',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.border, height: 1),
        
        Expanded(
          child: products.isEmpty 
              ? const EmptySearchState()
              : SearchResultsGrid(products: products),
        ),
      ],
    );
  }
}
