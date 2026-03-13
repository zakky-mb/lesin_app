import 'package:flutter/material.dart';

class PaymentMethodBottomSheet extends StatefulWidget {
  final String initialMethod;
  final Function(String) onMethodSelected;

  const PaymentMethodBottomSheet({
    Key? key,
    required this.initialMethod,
    required this.onMethodSelected,
  }) : super(key: key);

  @override
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  late String _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.initialMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Pilih Metode Pembayaran',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142)),
          ),
          const SizedBox(height: 16),

          // Opsi LesPay
          _buildPaymentOption(
            icon: Icons.account_balance_wallet,
            title: 'LesPay',
            subtitle: 'Saldo: Rp 250.000',
            value: 'LesPay',
          ),
          const SizedBox(height: 12),

          // Opsi Tunai
          _buildPaymentOption(
            icon: Icons.money,
            title: 'Tunai (Cash)',
            subtitle: 'Bayar langsung ke guru',
            value: 'Cash',
          ),

          const SizedBox(height: 24),

          // Tombol Konfirmasi
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.onMethodSelected(_selectedMethod);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9A9E), // Peach Color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Konfirmasi Pilihan',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10), // Safe area bottom
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    bool isSelected = _selectedMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF9A9E).withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9A9E) : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF9A9E) : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142)),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFFFF9A9E), size: 28),
          ],
        ),
      ),
    );
  }
}
