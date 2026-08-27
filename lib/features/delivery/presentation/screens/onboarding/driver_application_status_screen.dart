import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/delivery/presentation/state/mock_delivery_state.dart';
import 'package:zyra_shop/features/delivery/presentation/screens/onboarding/driver_contract_screen.dart';
import 'package:zyra_shop/features/delivery/presentation/screens/onboarding/driver_registration_screen.dart';

class DriverApplicationStatusScreen extends StatefulWidget {
  const DriverApplicationStatusScreen({super.key});

  @override
  State<DriverApplicationStatusScreen> createState() => _DriverApplicationStatusScreenState();
}

class _DriverApplicationStatusScreenState extends State<DriverApplicationStatusScreen> {
  int _devTapCount = 0;

  void _handleDevTap() {
    _devTapCount++;
    if (_devTapCount == 5) {
      _devTapCount = 0;
      // Show dev bottom sheet
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('[DEV] Changer le statut', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Approuver la demande'),
                leading: const Icon(Icons.check_circle, color: Colors.green),
                onTap: () {
                  MockDeliveryState().devSetStatus(DriverStatus.approved);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('Rejeter la demande'),
                leading: const Icon(Icons.cancel, color: Colors.red),
                onTap: () {
                  MockDeliveryState().devSetStatus(DriverStatus.rejected);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: const Text('Remettre en attente'),
                leading: const Icon(Icons.hourglass_empty, color: Colors.orange),
                onTap: () {
                  MockDeliveryState().devSetStatus(DriverStatus.pending);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: _handleDevTap,
          child: Text('Statut de la demande', style: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: MockDeliveryState(),
        builder: (context, _) {
          final status = MockDeliveryState().status;

          if (status == DriverStatus.approved) {
            return _buildApprovedState();
          } else if (status == DriverStatus.rejected) {
            return _buildRejectedState();
          }
          return _buildPendingState();
        },
      ),
    );
  }

  Widget _buildPendingState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.hourglass_bottom_rounded, size: 48, color: Colors.blue),
          ),
          const SizedBox(height: 32),
          Text('Demande envoyée', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Text(
            'Votre demande pour devenir livreur ZYRA a bien été enregistrée. Vous recevrez une réponse dès que votre dossier aura été examiné.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 48),
          
          // Timeline
          _buildTimelineItem(title: 'Demande envoyée', isCompleted: true, isLast: false),
          _buildTimelineItem(title: 'Documents reçus', isCompleted: true, isLast: false),
          _buildTimelineItem(title: 'Vérification par ZYRA', isCompleted: false, isActive: true, isLast: false),
          _buildTimelineItem(title: 'Décision finale', isCompleted: false, isActive: false, isLast: true),
        ],
      ),
    );
  }

  Widget _buildApprovedState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Text('🎉', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 32),
          Text('Félicitations !', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Text(
            'Votre demande pour devenir livreur ZYRA a été acceptée. Une dernière étape vous attend : lire et accepter votre contrat de livreur.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriverContractScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                'Voir mon contrat',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRejectedState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close_rounded, size: 48, color: Colors.red),
          ),
          const SizedBox(height: 32),
          Text('Demande non acceptée', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Text(
            'Malheureusement, nous ne pouvons pas donner suite à votre candidature pour le moment car certains documents ne sont pas conformes.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriverRegistrationScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.grey)),
                elevation: 0,
              ),
              child: Text(
                'Modifier ma demande',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({required String title, required bool isCompleted, bool isActive = false, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : (isActive ? AppColors.primary : Colors.grey.shade300),
                shape: BoxShape.circle,
              ),
              child: isCompleted 
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : (isActive ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))) : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isCompleted || isActive ? AppColors.textPrimary : Colors.grey.shade500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

