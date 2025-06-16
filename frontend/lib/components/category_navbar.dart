import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_style.dart';

class CategoryNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  final List<String> categories = const [
    'Bebidas Calientes',
    'Bebidas Heladas',
    'Comida',
    'Postres',
  ];

  const CategoryNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBackground,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            final bool isSelected = index == selectedIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.sectionTitle : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categories[index],
                    style: isSelected
                        ? AppTextStyle.sectionTitle.copyWith(color: Colors.white)
                        : AppTextStyle.body,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}