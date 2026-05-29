import 'package:flutter/material.dart';

class MenuItemModel {
  final IconData icon;
  final String label;
  final bool badge;
  final VoidCallback onTap;

  MenuItemModel({
    required this.icon,
    required this.label,
    this.badge = false,
    required this.onTap,
  });
}