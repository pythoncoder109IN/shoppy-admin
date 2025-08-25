import 'package:flutter/material.dart';

class AdditionalConfirm extends StatefulWidget {
  final String contentText;
  final VoidCallback onYes, onNo;
  const AdditionalConfirm({
    super.key,
    required this.contentText,
    required this.onYes,
    required this.onNo,
  });

  @override
  State<AdditionalConfirm> createState() => _AdditionalConfirmState();
}

class _AdditionalConfirmState extends State<AdditionalConfirm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF59E0B),
            size: 24,
          ),
          SizedBox(width: 12),
          Text(
            "Confirm Action",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
      content: Text(
        widget.contentText,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF64748B),
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onNo,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF64748B),
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: widget.onYes,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF4444),
            foregroundColor: Colors.white,
          ),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
