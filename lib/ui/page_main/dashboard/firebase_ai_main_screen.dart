import 'package:boilerplate_3_firebaseconnect/core/utilities/extensions/primitive_data/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/models/features/chatbot_ai.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/state_management/providers/auth/user_provider.dart';
import '../../../core/state_management/providers/features/firebase_ai_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/page_routes_func.dart';
import '../../../core/utilities/functions/system_func.dart';
import '../../layouts/global_return_widgets/future_state_func.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/custom_text/markdown_text.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/global_state_widgets/textfield/textfield_form/animate_form.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';
import 'firebase_ai_history_screen.dart';

class FirebaseAIMainScreen extends StatelessWidget {
  const FirebaseAIMainScreen({super.key});

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
      padding: EdgeInsets.symmetric(horizontal: paddingNear),
      appBar: appBarWidget(context: context, title: 'Chatbot AI', showBackButton: true, actions: [
        IconButton(onPressed: () => startScreenSwipe(context, FirebaseAIHistoryScreen()), icon: Icon(Icons.message_rounded, color: ThemeColors.surface(context)))
      ]),
      onPopInvokedWithResult: (cond, object) => FirebaseAIProvider.read(context).clearConversation(),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.symmetric(horizontal: paddingNear),
      appBar: appBarWidget(context: context, title: 'Chatbot AI', showBackButton: true, actions: [
        IconButton(onPressed: () {
          startScreenSwipe(context, FirebaseAIHistoryScreen());
        }, icon: Icon(Icons.message_rounded, color: ThemeColors.surface(context)))
      ]),
      onPopInvokedWithResult: (cond, object) => FirebaseAIProvider.read(context).clearConversation(),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Column(
      children: [
        Consumer<FirebaseAIProvider>(
          builder: (context, provider, child) {
            if (provider.conversationLoading) return Expanded(child: onLoadingState(context: context, response: 'Memuat percakapan...'));
            if (provider.listChatbotMessage.isEmpty) return Expanded(child: onEmptyState(context: context, response: 'Percakapan Kosong', description: 'Mulailah mengirim pertanyaan Anda!'));
            if (provider.listChatbotMessage.isNotEmpty) {
              return Expanded(
                child: SizedBox(
                  child: ListView.separated(
                    controller: provider.scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: paddingNear * 1.5),
                    itemCount: provider.listChatbotMessage.length,
                    separatorBuilder: (c, i) => ColumnDivider(),
                    itemBuilder: (context, index){
                      var item = provider.listChatbotMessage[index];
                      bool isLast = index == provider.listChatbotMessage.length - 1;
                      return _bubbleChat(context, item, item.sender == UserProvider.read(context).user?.name ? true : false, isLast, provider.chatLoading);
                    },
                  ),
                ),
              );
            }
            return Expanded(child: onFailedState(context: context, response: 'Gagal memuat percakapan!', description: 'Terjadi masalah saat memuat percakapan!', onTap: () => Navigator.pop(context)));
          },
        ),
        AnimateTextField(
          labelText: 'Apa yang ingin Anda tanyakan?',
          controller: FirebaseAIProvider.read(context).tecConversation,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-!?#.,_\s]')),
          ],
          minInput: 6,
          maxInput: 200,
          containerColor: ThemeColors.greyVeryLowContrast(context),
          shadowColor: ThemeColors.surface(context),
          borderAnimationColor: ThemeColors.blueHighContrast(context),
          suffixIcon: Icon(Icons.send, size: iconBtnMid),
          suffixOnTap: () => FirebaseAIProvider.read(context).addDialog(context),
        ),
        ColumnDivider(space: spaceNear * .5),
        cText(context, 'Menggunakan Gemini 2.5 Flash.\nFitur Experimental! Gemini tidak dapat mengingat percakapan Anda sebelumnya!',
          align: TextAlign.center, style: TextStyles.micro(context)),
        ColumnDivider(space: spaceNear * .5),
      ],
    );
  }

  Widget _bubbleChat(BuildContext context, ChatbotMessage data, bool isMe, bool isLast, bool isChatLoading) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: paddingMid),
        child: Container(
          constraints: BoxConstraints(minWidth: getMediaQueryWidth(context) * 0.2, maxWidth: getMediaQueryWidth(context) * 0.9),
          padding: EdgeInsets.fromLTRB(paddingMid, paddingMid, paddingMid, 0),
          decoration: BoxDecoration(
            color: isMe ? ThemeColors.greyLowContrast(context) : ThemeColors.blueVeryLowContrast(context),
            borderRadius: BorderRadius.circular(radiusTriangle).copyWith(
              topLeft: isMe ? Radius.circular(radiusTriangle) : Radius.zero,
              topRight: isMe ? Radius.zero : Radius.circular(radiusTriangle),
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe) ...[
                    Icon(Icons.auto_awesome, size: iconBtnSmall, color: ThemeColors.purpleVeryHighContrast(context)),
                    RowDivider(space: spaceNear)
                  ],
                  cText(context, data.sender ?? 'unknown', style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.surface(context))),
                ],
              ),
              ColumnDivider(space: 1),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe && isLast && isChatLoading)...[
                    LoadingAnimationWidget.threeRotatingDots(color: ThemeColors.purpleHighContrast(context), size: iconBtnMid),
                    RowDivider(space: spaceNear),
                  ],
                  Flexible(fit: FlexFit.loose, child: FirebaseAIMarkdown(text: data.dialog ?? 'dialog error', isMe: isMe)),
                ],
              ),
              ColumnDivider(space: 1),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose, child: cText(context, data.createdAt.toString().formattedDate(context: context),
                        style: TextStyles.verySmall(context).copyWith(fontStyle: FontStyle.italic, color: ThemeColors.grey(context))),
                  ),
                  RowDivider(space: spaceNear),
                  IconButton(icon: Icon(Icons.share, size: iconBtnSmall), color: ThemeColors.green(context),
                      onPressed: () async => await shareContent(context, '${data.sender}:\n${data.dialog}\n\n${data.createdAt.toString().formattedDate(context: context)}')),
                  IconButton(icon: Icon(Icons.copy, size: iconBtnSmall), color: ThemeColors.blueVeryHighContrast(context),
                      onPressed: () => copyText(context, '${data.sender}:\n${data.dialog}\n\n${data.createdAt.toString().formattedDate(context: context)}', response: 'Pesan berhasil disalin')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}