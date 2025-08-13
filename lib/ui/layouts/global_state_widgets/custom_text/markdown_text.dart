import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';

class RegularMarkdown extends StatelessWidget {
  final String text;
  const RegularMarkdown({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        h1: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h2: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h3: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h4: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h5: TextStyles.semiMedium(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h6: TextStyles.small(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        p: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context)),
        strong: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        em: TextStyles.medium(context).copyWith(fontStyle: FontStyle.italic, color: ThemeColors.surface(context)),
        listBullet: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context)),
        unorderedListAlign: WrapAlignment.start,
      ),
    );
  }
}

class FirebaseAIMarkdown extends StatelessWidget {
  final String text;
  final bool isMe;

  const FirebaseAIMarkdown({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        h1: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h2: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h3: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h4: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h5: TextStyles.semiMedium(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        h6: TextStyles.small(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        p: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context)),
        strong: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context)),
        em: TextStyles.medium(context).copyWith(fontStyle: FontStyle.italic, color: ThemeColors.surface(context)),
        listBullet: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context)),
        horizontalRuleDecoration: BoxDecoration(border: Border(top: BorderSide(width: 2, color: ThemeColors.grey(context).withValues(alpha: .75)))),
        codeblockDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusSquare),
          color: ThemeColors.greyVeryLowContrast(context),
        ),
        unorderedListAlign: isMe ? WrapAlignment.end : WrapAlignment.start,
      ),
    );
  }
}
