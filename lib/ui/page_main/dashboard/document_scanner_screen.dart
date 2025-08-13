import 'package:boilerplate_3_firebaseconnect/core/state_management/providers/features/document_scanner_provider.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:provider/provider.dart';

import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/styleconfig/textstyle.dart';

class DocumentScannerScreen extends StatelessWidget {
  const DocumentScannerScreen({super.key});

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
        padding: EdgeInsets.zero,
        appBar: appBarWidget(context: context, title: 'Document Scanner', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
        useSafeArea: true,
        padding: EdgeInsets.zero,
        appBar: appBarWidget(context: context, title: 'Document Scanner', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DocumentScannerProvider(),
      child: Consumer<DocumentScannerProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              AnimateProgressButton(
                labelButton: 'Mulai Scan Dokumen',
                icon: Icon(Icons.document_scanner_outlined),
                onTap: () {
                  if (provider.isScanning) return;
                  provider.initializeScanner(DocumentScannerOptions(documentFormat: DocumentFormat.pdf, pageLimit: 3, mode: ScannerMode.full, isGalleryImport: true));
                  provider.startScanning();
                },
              ),
              if (provider.scanResult != null)
                cText(context, 'Scanned ${provider.scanResult!.images.length} images'),
              if (provider.errorMessage != null)
                cText(context, 'Error: ${provider.errorMessage}'),
            ],
          );
        },
      ),
    );
  }
}