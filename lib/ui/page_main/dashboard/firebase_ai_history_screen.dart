import 'package:boilerplate_3_firebaseconnect/core/utilities/extensions/primitive_data/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/models/features/chatbot_ai.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/state_management/providers/features/firebase_ai_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../layouts/global_return_widgets/future_state_func.dart';
import '../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';

class FirebaseAIHistoryScreen extends StatelessWidget {
  const FirebaseAIHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (provider.isTabletMode.condition) {
          if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context);
          if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context);
        }
        return _setPhoneLayout(context);
      }
    );
  }

  Widget _setPhoneLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.symmetric(horizontal: paddingMid),
      appBar: appBarWidget(context: context, title: 'Chatbot History', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.symmetric(horizontal: paddingMid),
      appBar: appBarWidget(context: context, title: 'Chatbot History', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Column(
      children: [
        Consumer<FirebaseAIProvider>(
          builder: (context, provider, child) {
            if (provider.conversationLoading) return Expanded(child: onLoadingState(context: context, response: 'Memuat percakapan...'));
            if (provider.listChatbotConversation.isEmpty) return Expanded(child: onEmptyState(context: context, response: 'Percakapan Kosong', description: 'Buat percakapan baru dengan klik tombol di bawah!'));
            if (provider.listChatbotConversation.isNotEmpty) {
              return Expanded(
                child: SizedBox(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: provider.listChatbotConversation.length,
                    separatorBuilder: (c, i) => ColumnDivider(),
                    itemBuilder: (context, index){
                      return _bubbleChat(context, provider.listChatbotConversation.reversed.toList()[index]);
                    },
                  ),
                ),
              );
            }
            return Expanded(child: onFailedState(context: context, response: 'Gagal memuat percakapan!', description: 'Terjadi masalah saat memuat percakapan!', onTap: () => Navigator.pop(context)));
          },
        ),
        AnimateProgressButton(
          labelButton: 'Buat Percakapan Baru',
          containerColorStart: ThemeColors.purpleHighContrast(context),
          containerColorEnd: ThemeColors.blueHighContrast(context),
          progressColor: ThemeColors.onSurface(context),
          shadowColor: ThemeColors.surface(context),
          onTap: () async {
            await FirebaseAIProvider.read(context).createNewConversation(context);
            Navigator.pop(context);
          },
        ),
        ColumnDivider(space: spaceNear),
      ],
    );
  }

  Widget _bubbleChat(BuildContext context, ChatbotConversation data) {
    List<ChatbotMessage> listChatbotMessage = data.messages!.map((x) => x).toList();
    return GestureDetector(
      onTap: () async {
        await FirebaseAIProvider.read(context).getConversation(context, data.conversationId);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(paddingFar),
        decoration: BoxDecoration(
          color: ThemeColors.greyLowContrast(context),
          borderRadius: BorderRadius.circular(radiusSquare),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.message_rounded, size: iconBtnMid, color: ThemeColors.purpleVeryHighContrast(context)),
            RowDivider(space: spaceNear),
            Expanded(child: cText(context, listChatbotMessage.length < 2 ? listChatbotMessage[0].dialog ?? 'unknown' : listChatbotMessage[1].dialog ?? 'unknown',
                maxLines: 2, style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold))),
            RowDivider(space: spaceNear),
            cText(context, listChatbotMessage.length < 2 ? listChatbotMessage[0].createdAt!.formattedDate(context: context) : listChatbotMessage[1].createdAt!.formattedDate(context: context),
                maxLines: 1, style: TextStyles.verySmall(context)),
          ],
        ),
      ),
    );
  }
}
