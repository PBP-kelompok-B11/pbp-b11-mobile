import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final VoidCallback? onTap; // optional callback untuk onTap

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, 
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: GestureDetector(
          onTap: onTap, // handle tap di sini
          child: Container(
            width: 1200,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(53),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.indigo,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.search,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: onSubmitted,
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.indigo,
                      fontFamily: 'Geologica',
                      height: 1.3,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Type to search...",
                      hintStyle: TextStyle(
                        fontSize: 24,
                        color: AppColors.indigo,
                        fontFamily: 'Geologica',
                        height: 1.3,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
