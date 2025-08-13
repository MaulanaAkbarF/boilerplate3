import 'dart:io';

import 'package:boilerplate_3_firebaseconnect/core/utilities/extensions/primitive_data/int_ext.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/dialog/dialog_action/loading_upload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constant_values/_constant_text_values.dart';
import '../../core/constant_values/_setting_value/log_app_values.dart';
import '../../core/constant_values/global_values.dart';
import '../../core/global_values/global_data.dart';
import '../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../core/state_management/providers/_settings/log_app_provider.dart';
import '../../core/utilities/functions/document_func.dart';
import '../../core/utilities/functions/logger_func.dart';
import '../../core/utilities/functions/media_query_func.dart';
import '../../core/utilities/functions/page_routes_func.dart';
import '../../core/utilities/functions/system_func.dart';
import '../../core/utilities/local_storage/isar_local_db/collections/_setting_collection/log_app.dart';
import '../../core/utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '../layouts/global_return_widgets/future_state_func.dart';
import '../layouts/global_return_widgets/helper_widgets_func.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../layouts/global_state_widgets/dialog/dialog_button/dialog_two_button.dart';
import '../layouts/global_state_widgets/divider/custom_divider.dart';
import '../layouts/styleconfig/textstyle.dart';
import '../layouts/styleconfig/themecolors.dart';

class LogAppSettingScreen extends StatelessWidget {
  final String dbSize;
  const LogAppSettingScreen({super.key, required this.dbSize});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (provider.isTabletMode.condition){
          if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context);
          if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context);
        }
        return _setPhoneLayout(context);
      }
    );
  }

  Widget _setPhoneLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      appBar: _appBar(context),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      appBar: _appBar(context),
      body: _bodyWidget(context)
    );
  }

  AppBar _appBar(BuildContext context){
    return appBarWidget(context: context, title: 'Log Aplikasi', showBackButton: true, showPopupMenuButton: true,
      onPopupMenuSelected: (value) async {
        switch (value) {
          case '0': await LogAppSettingProvider.read(context).initialize(); break;
          case '1': {
            showDialog(context: context, builder: (context) => DialogTwoButton(
            header: 'Hapus Semua Log', description: 'Anda yakin ingin menghapus semua Log Aplikasi?', acceptedOnTap: () async {
              await LogAppSettingProvider.read(context).deleteAllLog();
              Navigator.pop(context);
            }));
          } break;
          case '2': await showDialog(context: context, builder: (context) => DialogProccess(
            header: 'Mencetak Log Aplikasi',
            description: 'Memulai proses mencetak log aplikasi.\n\nHarap tunggu.\nProses ini dapat memerlukan beberapa waktu, bergantung dengan ukuran log aplikasi',
            onProcess: () async => await Future.delayed(Duration(milliseconds: 500)).then((_) async =>
              await createLogAppPdf(context, LogAppSettingProvider.read(context).listLogApp)))); break;
          case '3': await showDialog(context: context, builder: (context) => DialogProccess(
              header: 'Mencetak Log Aplikasi',
              description: 'Memulai proses mencetak log aplikasi.\n\nHarap tunggu.\nProses ini dapat memerlukan beberapa waktu, bergantung dengan ukuran log aplikasi',
              onProcess: () async => await Future.delayed(Duration(milliseconds: 500)).then((_) async =>
              await createLogAppJson(context, LogAppSettingProvider.read(context).listLogApp)))); break;

          case '4': await startScreenSwipe(context, LogAppDocumentScreen()); break;
        }
      },
      popupMenuItemBuilder: (context){
        return [
          popupMenuItem(context, '0', 'Segarkan', Icons.refresh, ThemeColors.green(context)),
          popupMenuItem(context, '1', 'Bersihkan Log ($dbSize)', Icons.delete_rounded, ThemeColors.redHighContrast(context)),
          popupMenuItem(context, '2', 'Cetak Log PDF', Icons.print, ThemeColors.red(context)),
          popupMenuItem(context, '3', 'Cetak Log JSON', Icons.print, ThemeColors.grey(context)),
          popupMenuItem(context, '4', 'Buka Log Dokumen', Icons.insert_drive_file, ThemeColors.blue(context)),
        ];
      }
    );
  }

  Widget _bodyWidget(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: paddingNear),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (GlobalData.isarOpenFailedMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(paddingMid),
              decoration: BoxDecoration(
                  color: ThemeColors.redVeryLowContrast(context),
                  borderRadius: BorderRadius.circular(radiusSquare)
              ),
              child: cText(context, GlobalData.isarOpenFailedMessage ?? 'Terjadi masalah', align: TextAlign.center),
            ),
            ColumnDivider(),
          ],
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ThemeColors.greyVeryLowContrast(context),
                borderRadius: BorderRadius.circular(radiusSquare)
              ),
              child: Consumer<LogAppSettingProvider>(
                builder: (context, provider, child) {
                  return DefaultTabController(length: 3, child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'Semua Log'),
                          Tab(text: 'Error APK'),
                          Tab(text: 'Error API')
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            provider.listLogApp.isNotEmpty ? ListView.builder(itemCount: provider.listLogApp.length, itemBuilder: (context, index) => _listItemBuilder(context, provider.listLogApp[index]))
                              : onEmptyState(context: context, response: 'Tidak ada Log Aplikasi'),
                            provider.listLogAppError.isNotEmpty ? ListView.builder(itemCount: provider.listLogAppError.length, itemBuilder: (context, index) => _listItemBuilder(context, provider.listLogAppError[index]))
                              : onEmptyState(context: context, response: 'Tidak ada Log Error Aplikasi'),
                            provider.listLogResponseError.isNotEmpty ? ListView.builder(itemCount: provider.listLogResponseError.length,itemBuilder: (context, index) => _listItemBuilder(context, provider.listLogResponseError[index]))
                              : onEmptyState(context: context, response: 'Tidak ada Log Error API'),
                          ],
                        ),
                      )],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listItemBuilder(BuildContext context, LogAppCollection data){
    int maxLinesLog = 10;
    Color warningColor = ThemeColors.surface(context);
    if (data.level != null){
      if (data.level!.contains(ListLogAppLevel.critical.level)) warningColor = ThemeColors.red(context);
      else if (data.level!.contains(ListLogAppLevel.severe.level)) warningColor = ThemeColors.orange(context);
      else if (data.level!.contains(ListLogAppLevel.moderate.level)) warningColor = ThemeColors.yellow(context);
      else if (data.level!.contains(ListLogAppLevel.low.level)) warningColor = ThemeColors.green(context);
      else warningColor = ThemeColors.surface(context);
    }

    return Padding(
      padding: const EdgeInsets.all(paddingNear),
      child: StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () => setState((){
              if (maxLinesLog == 500) maxLinesLog = 10;
              else maxLinesLog = 500;
            }),
            child: Container(
              decoration: BoxDecoration(
                color: ThemeColors.greyLowContrast(context).withValues(alpha: .5),
                borderRadius: BorderRadius.circular(radiusSquare * .5)
              ),
              child: Padding(
                padding: const EdgeInsets.all(paddingNear),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _listTextBuilder(context, 'Level', data.level, warningColor),
                    _listTextBuilder(context, 'Waktu Terjadi', '${data.logDate.toString()} [${data.id}]', ThemeColors.purpleHighContrast(context)),
                    _listTextBuilder(context, 'Status Code', data.statusCode.toString(), null),
                    _listTextBuilder(context, 'Masalah Utama', data.title, null),
                    _listTextBuilder(context, 'Sub Judul', data.subtitle, null),
                    _listTextBuilder(context, 'Deskripsi', data.description, null),
                    cText(context, 'LOG', align: TextAlign.left, style: TextStyles.verySmall(context).copyWith(fontWeight: FontWeight.bold)),
                    cText(context, data.logs ?? '', maxLines: maxLinesLog, align: TextAlign.left, style: TextStyles.verySmall(context).copyWith(fontStyle: FontStyle.italic)),
                    _actionButton(context, data)
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _listTextBuilder(BuildContext context, String title, String? value, Color? color){
    return value != null && value != 'null' ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: cText(context, title, align: TextAlign.left, style: TextStyles.verySmall(context).copyWith(fontWeight: FontWeight.bold))),
        cText(context, ':', align: TextAlign.left, style: TextStyles.verySmall(context).copyWith(fontWeight: FontWeight.bold)),
        RowDivider(),
        Expanded(flex: 7, child: cText(context, value, align: TextAlign.left, style: color != null ? TextStyles.verySmall(context).copyWith(color: color) : TextStyles.verySmall(context)))
      ],
    ) : const SizedBox();
  }

  Widget _actionButton(BuildContext context, LogAppCollection data){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // TextButton(child: cText(context, 'Expand', style: TextStyles.small(context).copyWith(fontWeight: FontWeight.bold)), onPressed: () => print('Press')),
        IconButton(icon: Icon(Icons.share, size: iconBtnSmall), color: ThemeColors.green(context), onPressed: () async => await shareContent(context, '${data.title}\n${data.logs}')),
        IconButton(icon: Icon(Icons.copy, size: iconBtnSmall), color: ThemeColors.blue(context), onPressed: () => copyText(context, '${data.title}\n${data.logs}', response: 'Log berhasil disalin')),
        IconButton(icon: Icon(Icons.cancel, size: iconBtnSmall), color: ThemeColors.red(context), onPressed: () =>
          showDialog(context: context, builder: (context) => DialogTwoButton(
            header: 'Hapus Log', description: 'Anda yakin ingin menghapus Log yang Anda pilih?', acceptedOnTap: () async {
            await LogAppSettingProvider.read(context).deleteSelectedLog(data.id);
            Navigator.pop(context);
          })))
      ],
    );
  }
}

class LogAppDocumentScreen extends StatefulWidget {
  const LogAppDocumentScreen({super.key});

  @override
  State<LogAppDocumentScreen> createState() => _LogAppDocumentScreenState();
}

class _LogAppDocumentScreenState extends State<LogAppDocumentScreen> {
  Future<List<File>> _loadLogAppDocFile() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final List<FileSystemEntity> files = directory.listSync();
        return files.where((file) => (file.path.endsWith('.pdf') || file.path.endsWith('.json')) &&
            file.path.contains('log_app_$appNameText')).map((file) => File(file.path)).toList()..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else {
        return [];
      }
    } catch (e, s) {
      clog('Terjadi masalah saat logAppDocFile: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return [];
    }
  }

  Future<void> _deleteFile(File file) async {
    try {
      await file.delete();
      await _loadLogAppDocFile();
    } catch (e, s) {
      clog('Terjadi masalah saat _deleteFile: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    }
  }

  IconData _getFileIcon(String filePath) {
    if (filePath.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else if (filePath.endsWith('.json')) {
      return Icons.data_object;
    }
    return Icons.insert_drive_file;
  }

  Color _getFileIconColor(BuildContext context, String filePath) {
    if (filePath.endsWith('.pdf')) {
      return ThemeColors.red(context);
    } else if (filePath.endsWith('.json')) {
      return ThemeColors.blue(context);
    }
    return ThemeColors.grey(context);
  }

  String _getFileTypeLabel(String filePath) {
    if (filePath.endsWith('.pdf')) {
      return 'PDF';
    } else if (filePath.endsWith('.json')) {
      return 'JSON';
    }
    return 'FILE';
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      appBar: appBarWidget(context: context, title: 'Daftar Log Dokumen', showBackButton: true),
      body: StatefulBuilder(
        builder: (context, setState) {
          return FutureBuilder<List<File>>(
            future: _loadLogAppDocFile(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return onFailedState(context: context, description: 'Terjadi Masalah pada Dokumen Log App');
                } else if (snapshot.data?.isEmpty ?? false){
                  return onEmptyState(context: context, description: 'Dokumen Log App Kosong');
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: paddingMid),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (context, index) => ColumnDivider(),
                      itemBuilder: (context, index){
                        final itemData = snapshot.data![index];
                        final fileName = itemData.path.split('/').last;
                        final fileType = _getFileTypeLabel(itemData.path);

                        return Container(
                          decoration: BoxDecoration(color: ThemeColors.greyVeryLowContrast(context), borderRadius: BorderRadius.circular(radiusSquare)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: paddingNear),
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_getFileIcon(itemData.path), size: iconBtnMid, color: _getFileIconColor(context, itemData.path)),
                                cText(context, fileType, style: TextStyles.verySmall(context).copyWith(fontWeight: FontWeight.bold, color: _getFileIconColor(context, itemData.path))),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cText(context, '$fileName [$index]'),
                                cText(context, itemData.lengthSync().readAsByte, style: TextStyles.verySmall(context).copyWith(fontWeight: FontWeight.bold)),
                                cText(context, 'Dibuat: ${DateFormat('dd/MM/yyyy HH:mm').format(itemData.lastModifiedSync())}', style: TextStyles.verySmall(context).copyWith(color: ThemeColors.grey(context))),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async => await shareContent(context, 'Mengirim Dokumen Log Aplikasi ($fileType)', imageFiles: [XFile(itemData.path)]),
                                  icon: Icon(Icons.share, color: ThemeColors.green(context), size: iconBtnMid)
                                ),
                                IconButton(
                                  onPressed: () => showDialog(context: context, builder: (context) => DialogTwoButton(
                                      header: 'Hapus Log Dokumen',
                                      description: 'Anda yakin ingin menghapus Log Dokumen berikut?\n$fileName\n',
                                      acceptedOnTap: () async {
                                        await _deleteFile(itemData).then((_) => setState(() => print('Delete Success')));
                                        Navigator.pop(context);
                                      }
                                    )
                                  ),
                                  icon: Icon(Icons.delete, color: ThemeColors.red(context), size: iconBtnMid)
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
              if (snapshot.hasError) return onFailedState(context: context, description: 'loadLogAppDocument Error: ${snapshot.error}');
              return onLoadingState(context: context);
            }
          );
        }
      ),
    );
  }
}