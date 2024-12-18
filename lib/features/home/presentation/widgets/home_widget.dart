import 'package:flutter/material.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/theme/text_theme.dart';

class RoomActionWidget extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color backgroundColor;
  final String text;

  const RoomActionWidget(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.backgroundColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(context.width > 1024 ? 16 : 8),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          Label(
            text: text,
            selectable: false,
            style: AppTextTheme.bodySmall,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
