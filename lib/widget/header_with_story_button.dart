import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../style/colors/fv_colors.dart';

class HeaderWithNewStoryButton extends StatelessWidget {
  const HeaderWithNewStoryButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: FvColors.blue.color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Center(
        child: GestureDetector(
          onTap: onPressed,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            dashPattern: [6, 4],
            color: Colors.grey,
            strokeWidth: 1.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'New Story',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
