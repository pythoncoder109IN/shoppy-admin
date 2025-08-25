import 'package:flutter/material.dart';

class HomeButton extends StatefulWidget {
  final String name;
  final VoidCallback onTap;
  const HomeButton({super.key, required this.name, required this.onTap});

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF6366F1),
                const Color(0xFF8B5CF6),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForButton(widget.name),
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                widget.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForButton(String name) {
    switch (name.toLowerCase()) {
      case 'orders':
        return Icons.shopping_bag_outlined;
      case 'products':
        return Icons.inventory_2_outlined;
      case 'promos':
        return Icons.local_offer_outlined;
      case 'banners':
        return Icons.image_outlined;
      case 'categories':
        return Icons.category_outlined;
      case 'coupons':
        return Icons.confirmation_number_outlined;
      default:
        return Icons.dashboard_outlined;
    }
  }
}

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Text(
            widget.name,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
