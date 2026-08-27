import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/delivery/domain/entities/delivery_order.dart';
import 'package:zyra_shop/features/delivery/presentation/state/mock_delivery_state.dart';
import 'package:zyra_shop/features/delivery/presentation/screens/deliveries/delivery_details_screen.dart';

class DriverDeliveriesScreen extends StatefulWidget {
  const DriverDeliveriesScreen({super.key});

  @override
  State<DriverDeliveriesScreen> createState() => _DriverDeliveriesScreenState();
}

class _DriverDeliveriesScreenState extends State<DriverDeliveriesScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Toutes';
  final List<String> _filters = ['Toutes', 'À récupérer', 'En cours', 'Livrées'];

  final Set<String> _selectedIds = {};

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
    });
  }

  void _performBulkAction(DeliveryStatus newStatus) {
    MockDeliveryState().bulkUpdateDeliveries(_selectedIds.toList(), newStatus);
    _clearSelection();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Livraisons mises à jour !'), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockDeliveryState(),
      builder: (context, _) {
        final allDeliveries = MockDeliveryState().deliveries;
        
        // Filter
        var filteredDeliveries = allDeliveries.where((d) {
          if (_selectedFilter == 'À récupérer') return d.status == DeliveryStatus.prepared;
          if (_selectedFilter == 'En cours') return d.status == DeliveryStatus.pickedUp || d.status == DeliveryStatus.outForDelivery;
          if (_selectedFilter == 'Livrées') return d.status == DeliveryStatus.delivered;
          return true; // Toutes
        }).toList();

        // Search
        if (_searchQuery.isNotEmpty) {
          filteredDeliveries = filteredDeliveries.where((d) => d.id.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
        }

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('Mes Livraisons', style: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              // Search & Filters
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Search bar
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Rechercher une commande (ex: ZY1234)',
                          hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Filters
                    SizedBox(
                      height: 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final filter = _filters[index];
                          final isSelected = _selectedFilter == filter;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                                _selectedIds.clear(); // clear selection on filter change
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.white,
                                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                filter,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // List
              Expanded(
                child: filteredDeliveries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text('Aucune livraison trouvée', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: filteredDeliveries.length,
                        itemBuilder: (context, index) {
                          final order = filteredDeliveries[index];
                          final isSelected = _selectedIds.contains(order.id);
                          
                          Color statusColor;
                          String statusText;

                          switch (order.status) {
                            case DeliveryStatus.prepared:
                              statusColor = Colors.orange;
                              statusText = 'À récupérer';
                              break;
                            case DeliveryStatus.pickedUp:
                              statusColor = Colors.blue;
                              statusText = 'Colis récupéré';
                              break;
                            case DeliveryStatus.outForDelivery:
                              statusColor = Colors.purple;
                              statusText = 'En livraison';
                              break;
                            case DeliveryStatus.delivered:
                              statusColor = Colors.green;
                              statusText = 'Livré';
                              break;
                          }

                          return GestureDetector(
                            onTap: () {
                              if (_selectedIds.isNotEmpty) {
                                _toggleSelection(order.id);
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryDetailsScreen(deliveryId: order.id)));
                              }
                            },
                            onLongPress: () => _toggleSelection(order.id),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
                                boxShadow: [
                                  if (!isSelected)
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  if (_selectedIds.isNotEmpty) ...[
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.primary : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade400),
                                      ),
                                      child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('#${order.id}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: statusColor.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(statusText, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(order.customerName, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(order.zone, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                                            const SizedBox(width: 12),
                                            const Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text('${order.itemCount} articles', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          bottomNavigationBar: _selectedIds.isEmpty
              ? null
              : Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_selectedIds.length} sélectionnée(s)', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                            GestureDetector(
                              onTap: _clearSelection,
                              child: Text('Annuler', style: GoogleFonts.inter(color: Colors.grey, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _performBulkAction(DeliveryStatus.pickedUp),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: Text('Récupérées', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _performBulkAction(DeliveryStatus.delivered),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: Text('Livrées', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

