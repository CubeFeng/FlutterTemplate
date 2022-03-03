import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_kit/flutter_base_kit.dart';
import 'package:flutter_ucore/generated/i18n_keys.dart';
import 'package:flutter_ucore/i18n/i18n.dart';
import 'package:flutter_ucore/modules/login/controllers/user_protocol_controller.dart';
import 'package:flutter_ucore/services/local_service.dart';
import 'package:flutter_ucore/widgets/ucore_app_bar.dart';

class UserProtocolView extends GetView<UserProtocolController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UCoreAppBar(
        title: Text(I18nKeys.users_agreement_t),
      ),
      body: Center(
        child: FutureBuilder<PDFDocument>(
          initialData: null,
          future: PDFDocument.fromAsset(
              LocalService.to.language == SupportedLocales.zh_TW
                  ? 'assets/pdfs/tradeagreementft.pdf'
                  : 'assets/pdfs/tradeagreementjt.pdf'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PDFViewer(
                document: snapshot.data!,
                showNavigation: false,
                showPicker: false,
                scrollDirection: Axis.vertical,
              );
            } else {
              return CupertinoActivityIndicator();
            }
          },
        ),
      ),
    );
  }
}
