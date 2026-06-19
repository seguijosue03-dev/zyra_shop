import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/messaging/presentation/state/mock_messaging_state.dart';
import 'package:zyra_shop/features/messaging/presentation/widgets/conversation_card.dart';
import 'package:zyra_shop/shared/widgets/empty_state_widget.dart';

class ConversationsListScreen extends StatefulWidget {
  const ConversationsListScreen({super.key});

  @override
  State<ConversationsListScreen> createState() => _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  String _filter = 'Toutes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text('Messages', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une conversation',
                  hintStyle: GoogleFonts.inter(color: Colors.black45, fontSize: 15),
                  prefixIcon: const Icon(Icons.search, color: Colors.black45),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: ['Toutes', 'Non lues', 'Vendeurs'].map((label) {
                final isSelected = _filter == label;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label, style: GoogleFonts.inter(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500)),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _filter = label);
                    },
                    selectedColor: Colors.black87,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.black.withOpacity(0.1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),
          
          Container(height: 1, color: Colors.black.withOpacity(0.05)),
          
          // List
          Expanded(
            child: ListenableBuilder(
              listenable: MockMessagingState(),
              builder: (context, _) {
                final allConvs = MockMessagingState().conversations;
                var filtered = allConvs;
                
                if (_filter == 'Non lues') {
                  filtered = allConvs.where((c) => c.unreadCount > 0).toList();
                } else if (_filter == 'Vendeurs') {
                  filtered = allConvs.where((c) => c.isSeller).toList();
                }

                if (filtered.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return ConversationCard(conversation: filtered[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateWidget(
      title: 'Aucune conversation',
      message: 'Contactez un vendeur pour commencer à discuter.',
      icon: Icons.chat_bubble_outline,
    );
  }
}
