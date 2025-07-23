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
    return SizedBox(
      height: DesignSystem.searchBarHeight,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: DesignSystem.bodyLarge,
        decoration: InputDecoration(
          filled: true,
          // fillColor: DesignSystem.inputBackground,
          hintText: 'Search for station',
          hintStyle: DesignSystem.bodyLarge.copyWith(
            color: DesignSystem.grey600,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: DesignSystem.grey600,
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: onClear,
                  child: const Icon(
                    Icons.clear,
                    color: DesignSystem.grey600,
                    size: 20,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacing16,
            vertical: DesignSystem.spacing12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignSystem.borderRadius28),
            borderSide: const BorderSide(
              color: DesignSystem.grey100,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignSystem.borderRadius28),
            borderSide: const BorderSide(
              color: DesignSystem.bluePrimary600,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
