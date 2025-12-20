import 'package:flutter/material.dart';

/// ===============================
/// BUTTON: History / Delete All
/// ===============================
class SearchActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const SearchActionButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 240,
        height: 48,
        child: Stack(
          children: [
            Container(
              width: 240,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFA3E635),
                borderRadius: BorderRadius.circular(36),
              ),
            ),
            Positioned(
              left: 12,
              top: 5,
              child: SizedBox(
                width: 208,
                height: 40,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF312E81),
                      fontSize: 24,
                      fontFamily: 'Geologica',
                      fontWeight: FontWeight.w400,
                      height: 1.67,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// SEARCH HISTORY ITEM
/// ===============================
class SearchHistoryItem extends StatelessWidget {
  final String text;
  final VoidCallback? onDelete;

  const SearchHistoryItem({
    super.key,
    required this.text,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 955,
      height: 112,
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(53),
        border: Border.all(
          color: const Color(0xFFA3E635),
          width: 4,
        ),
      ),
      child: Stack(
        children: [
          /// LEFT ICON (History)
          Positioned(
            left: 37,
            top: 29,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFA3E635),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history,
                size: 32,
                color: Colors.black,
              ),
            ),
          ),

          /// TEXT
          Positioned(
            left: 112,
            top: 30,
            child: SizedBox(
              width: 400,
              height: 50,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),
          ),

          /// RIGHT ICON (Close)
          Positioned(
            right: 37,
            top: 29,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFA3E635),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 32,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
