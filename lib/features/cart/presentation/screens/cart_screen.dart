import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/state/app_state.dart';
import 'package:zyra_shop/shared/widgets/empty_state_widget.dart';
import 'package:zyra_shop/features/checkout/presentation/screens/checkout_address_screen.dart' as zyra_checkout;

class CartScreen extends StatefulWidget {
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToFavorites;

  const CartScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToFavorites,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _cartTabIndex = 0;
  final Set<String> _unselectedCartItemKeys = {};

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final List<CartItemMock> cartItems = AppState().cartItems;
        
        // Calculate selected count and total based on unselected keys
        int selectedCount = 0;
        double selectedTotal = 0;
        for (var item in cartItems) {
          final key = '${item.product.id}_${item.size}_${item.color.value}';
          if (!_unselectedCartItemKeys.contains(key)) {
            selectedCount++;
            selectedTotal += item.product.price * item.quantity;
          }
        }
        final bool isAllSelected = selectedCount == cartItems.length && cartItems.isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87), 
              onPressed: widget.onNavigateToHome,
            ),
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(AppState().shippingAddressName ?? 'Mon Panier', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    if (AppState().shippingAddressName != null) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black87),
                    ]
                  ],
                ),
                if (AppState().shippingAddressLocation != null)
                  Text(AppState().shippingAddressLocation!, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.black87), 
                onPressed: widget.onNavigateToFavorites,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildCartTab('Articles', 0),
                        _buildCartTab('Coupons & Offres', 1),
                        _buildCartTab('ZYRA Currency', 2),
                      ],
                    ),
                  ),
                  Container(height: 1, color: AppColors.border),
                ],
              ),
            ),
          ),
          body: cartItems.isEmpty
              ? EmptyStateWidget(
                  title: 'Votre panier est vide',
                  message: 'Découvrez nos produits et ajoutez-les à votre panier.',
                  icon: Icons.shopping_bag_outlined,
                  actionLabel: 'Faire mes achats',
                  onActionPressed: widget.onNavigateToHome,
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Header
                          Text('Votre Panier', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isAllSelected) {
                                      // Unselect all
                                      for (var item in cartItems) {
                                        _unselectedCartItemKeys.add('${item.product.id}_${item.size}_${item.color.value}');
                                      }
                                    } else {
                                      // Select all
                                      _unselectedCartItemKeys.clear();
                                    }
                                  });
                                },
                                child: Icon(
                                  isAllSelected ? Icons.check_box : Icons.check_box_outline_blank, 
                                  color: isAllSelected ? AppColors.primary : Colors.grey.shade500, 
                                  size: 20
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('$selectedCount/${cartItems.length} Articles sélectionnés', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  if (selectedCount > 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Partage de $selectedCount article(s)...'), duration: const Duration(seconds: 1)));
                                  }
                                },
                                child: Icon(Icons.share_outlined, size: 20, color: Colors.grey.shade700),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  if (selectedCount > 0) {
                                    final indicesToRemove = <int>[];
                                    for (int i = 0; i < cartItems.length; i++) {
                                      final item = cartItems[i];
                                      final key = '${item.product.id}_${item.size}_${item.color.value}';
                                      if (!_unselectedCartItemKeys.contains(key)) {
                                        indicesToRemove.add(i);
                                      }
                                    }
                                    AppState().removeItemsFromCart(indicesToRemove);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$selectedCount article(s) supprimé(s)'), duration: const Duration(seconds: 1)));
                                    setState(() {
                                      _unselectedCartItemKeys.clear();
                                    });
                                  }
                                },
                                child: Icon(Icons.delete_outline, size: 20, color: Colors.grey.shade700),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  if (selectedCount > 0) {
                                    final productIdsToFavorite = <String>[];
                                    for (int i = 0; i < cartItems.length; i++) {
                                      final item = cartItems[i];
                                      final key = '${item.product.id}_${item.size}_${item.color.value}';
                                      if (!_unselectedCartItemKeys.contains(key)) {
                                        productIdsToFavorite.add(item.product.id);
                                      }
                                    }
                                    AppState().addItemsToFavorites(productIdsToFavorite);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$selectedCount article(s) ajouté(s) aux favoris'), duration: const Duration(seconds: 1)));
                                  } else {
                                    widget.onNavigateToFavorites();
                                  }
                                },
                                child: Icon(Icons.favorite_border, size: 20, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Items
                          ...cartItems.asMap().entries.map((entry) {
                            return _buildMyntraCartItem(entry.key, entry.value, _unselectedCartItemKeys);
                          }),
                        ],
                      ),
                    ),
                    
                    // Checkout Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (selectedCount == 0)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFFE5E5), Color(0xFFFFCCCC)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Text(
                                  'Aucun article sélectionné, veuillez sélectionner au moins un article.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                                ),
                              ),
                            if (selectedCount > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total estimé',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '${selectedTotal.toStringAsFixed(0)} FCFA',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedCount > 0 ? AppColors.primary : Colors.grey.shade400,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 0,
                                  ),
                                  onPressed: selectedCount > 0 ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const zyra_checkout.CheckoutAddressScreen()),
                                    );
                                  } : null,
                                  child: Text('Passer la commande', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildCartTab(String title, int index) {
    bool isSelected = _cartTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _cartTabIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  void _showQtySelector(BuildContext context, int index, CartItemMock item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Sélectionnez la quantité', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, i) {
                    final qty = i + 1;
                    return ListTile(
                      title: Text('$qty', style: GoogleFonts.inter(fontWeight: qty == item.quantity ? FontWeight.bold : FontWeight.normal)),
                      trailing: qty == item.quantity ? const Icon(Icons.check, color: AppColors.primary) : null,
                      onTap: () {
                        AppState().updateCartQuantity(index, qty);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSizeSelector(BuildContext context, int index, CartItemMock item) {
    final sizes = ['S', 'M', 'L', 'XL', 'XXL'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Sélectionnez la taille', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ...sizes.map((s) => ListTile(
                title: Text(s, style: GoogleFonts.inter(fontWeight: s == item.size ? FontWeight.bold : FontWeight.normal)),
                trailing: s == item.size ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  AppState().updateCartSize(index, s);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyntraCartItem(int index, CartItemMock item, Set<String> unselectedKeys) {
    final product = item.product;
    final brand = product.category.toUpperCase();
    final oldPrice = product.oldPrice ?? (product.price * 1.6);
    final discountPercent = (((oldPrice - product.price) / oldPrice) * 100).round();
    
    final String itemKey = '${product.id}_${item.size}_${item.color.value}';
    final bool isChecked = !unselectedKeys.contains(itemKey);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox and Image
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8, top: 8),
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isChecked) {
                              unselectedKeys.add(itemKey);
                            } else {
                              unselectedKeys.remove(itemKey);
                            }
                          });
                        },
                        child: Container(
                          color: Colors.transparent, // expand tap area
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            isChecked ? Icons.check_box : Icons.check_box_outline_blank, 
                            color: isChecked ? AppColors.primary : Colors.black54, 
                            size: 20
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(brand, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                          GestureDetector(
                            onTap: () {
                              AppState().removeFromCart(index);
                              // Auto unselect key to keep count clean if we wanted to, 
                              // but since the item isn't rendered, it won't be counted anyway
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Article retiré du panier'), duration: Duration(seconds: 1)));
                            },
                            child: const Icon(Icons.close, size: 18, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Size Selector
                          GestureDetector(
                            onTap: () => _showSizeSelector(context, index, item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Text('Taille: ${item.size}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.black87),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Qty Selector
                          GestureDetector(
                            onTap: () => _showQtySelector(context, index, item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Text('Qté: ${item.quantity}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.black87),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('1 left', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade400)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${product.price.toStringAsFixed(0)} FCFA', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(width: 6),
                          Text(
                            oldPrice.toStringAsFixed(0),
                            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500, decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(width: 6),
                          Text('$discountPercent% Off', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.orange.shade400)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.keyboard_return, size: 12, color: Colors.black54),
                          const SizedBox(width: 4),
                          Text('Retour sous 7 jours', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
