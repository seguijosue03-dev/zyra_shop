import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_dashboard_state.dart';
import 'seller_product_form_screen.dart';
import 'seller_product_form_screen.dart';

class SellerProductsScreen extends StatelessWidget {
  const SellerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text('Mes Produits', style: GoogleFonts.inter(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: ListenableBuilder(
        listenable: MockDashboardState(),
        builder: (context, _) {
          final products = MockDashboardState().products;
          
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Aucun produit', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Text('Ajoutez votre premier produit pour commencer.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 80),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(
                context: context,
                id: product['id'],
                name: product['name'],
                price: product['price'],
                originalPrice: product['originalPrice'],
                discount: product['discount'],
                stock: product['stock'],
                imageUrl: product['imageUrl'],
                status: product['status'],
                statusColor: product['statusColor'],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerProductFormScreen()));
        },
        backgroundColor: const Color(0xFFFF4B72),
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Ajouter', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required String id,
    required String name,
    required String price,
    String? originalPrice,
    String? discount,
    required int stock,
    required String imageUrl,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerProductFormScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                  ),
                  child: discount != null
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4B72),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(discount, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (originalPrice != null) ...[
                            Text(originalPrice, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500, decoration: TextDecoration.lineThrough)),
                            const SizedBox(width: 6),
                          ],
                          Text(price, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: discount != null ? const Color(0xFFFF4B72) : Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$stock en stock', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.more_horiz_rounded, color: Colors.black54, size: 20),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerProductFormScreen()));
                                    } else if (value == 'delete') {
                                      MockDashboardState().deleteProduct(id);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produit supprimé')));
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(value: 'edit', child: Text('Modifier', style: GoogleFonts.inter())),
                                    PopupMenuItem(value: 'delete', child: Text('Supprimer', style: GoogleFonts.inter(color: Colors.red))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
