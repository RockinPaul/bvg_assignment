import 'package:flutter/material.dart';

import '../../core/constants/design_system.dart';

/// Search field widget with clear functionality based on design specifications
class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DesignSystem.searchBarHeight,
      decoration: BoxDecoration(
        color: DesignSystem.backgroundPrimary,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: DesignSystem.grey500,
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: DesignSystem.bodyLarge,
        decoration: InputDecoration(
          filled: false,
          hintText: 'Search for station',
          hintStyle: DesignSystem.bodyLarge.copyWith(
            color: DesignSystem.grey500,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: DesignSystem.grey500,
            size: 24,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: onClear,
                  child: const Icon(
                    Icons.clear,
                    color: DesignSystem.grey500,
                    size: 20,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacing16,
            vertical: DesignSystem.spacing12,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
