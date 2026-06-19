import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/messaging/domain/entities/message_entity.dart';
import 'package:zyra_shop/features/products/presentation/screens/product_detail_screen.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.orderStatus) {
      return _buildOrderStatusBubble();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, size: 14, color: Colors.black54),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF111827) : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
              ),
              child: _buildBubbleContent(context),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildBubbleContent(BuildContext context) {
    if (message.type == MessageType.productShare && message.productData != null) {
      return _buildProductShareCard(context);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: GoogleFonts.inter(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 15,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(message.timestamp),
                style: GoogleFonts.inter(
                  color: isMe ? Colors.white54 : Colors.black45,
                  fontSize: 10,
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.done_all,
                  size: 14,
                  color: message.isRead ? Colors.blueAccent : Colors.white54,
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductShareCard(BuildContext context) {
    final data = message.productData!;
    return Container(
      width: 240,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              data['image'],
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(data['name'], style: GoogleFonts.inter(color: isMe ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(data['price'], style: GoogleFonts.inter(color: isMe ? Colors.white70 : Colors.black54, fontSize: 13)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to product (mock behavior)
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ouverture du produit...')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isMe ? Colors.white : Colors.black87,
                foregroundColor: isMe ? Colors.black87 : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Voir le produit', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text('Mise à jour de commande', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 8),
              Text(message.text, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold)),
              if (message.orderStatusLabel != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (message.orderStatusColor ?? Colors.blue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.orderStatusLabel!,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: message.orderStatusColor ?? Colors.blue),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
