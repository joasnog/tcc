import 'package:flutter/material.dart';

class DataStructureItem extends StatelessWidget {
  const DataStructureItem({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData? icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 4),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            SizedBox(height: 8),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}