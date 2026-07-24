import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class FloatingBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final VoidCallback? onAddTapped;

  const FloatingBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.onAddTapped,
  });

  static const _icons = <IconData>[
    Icons.home_rounded,
    Icons.credit_card_rounded,
    Icons.add_rounded,
    Icons.receipt_long_rounded,
    Icons.pie_chart_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(78, 0, 78, 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.verdeEscuro.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.verdeMedio.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_icons.length, (index) {
                final isCentral = index == 2;

                if (isCentral) {
                  return GestureDetector(
                    onTap: onAddTapped,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.verdeDestaque,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.verdeDestaque,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.background,
                        size: 22,
                      ),
                    ),
                  );
                }

                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => onItemTapped(index),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 36,
                    child: Icon(
                      _icons[index],
                      color: isSelected ? AppColors.verdeDestaque : AppColors.cinzaClaro,
                      size: 22,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}