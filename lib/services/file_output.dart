import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Hands a generated file to the user: the share sheet on phones (Save to
/// Files / Drive / email…), a Save dialog on desktop. Returns a short status
/// message, or null if the user cancelled.
Future<String?> deliverFile(
  BuildContext context, {
  required String fileName,
  required Uint8List bytes,
  required String mimeType,
  String? subject,
}) async {
  if (Platform.isAndroid || Platform.isIOS) {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    if (!context.mounted) return null;
    final box = context.findRenderObject() as RenderBox?;
    final result = await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path, mimeType: mimeType)],
      subject: subject,
      sharePositionOrigin: box == null ? null : box.localToGlobal(Offset.zero) & box.size,
    ));
    return result.status == ShareResultStatus.dismissed ? null : 'Shared $fileName';
  }
  final uri = await FilePicker.saveFile(
    fileName: fileName,
    bytes: bytes,
    mimeType: mimeType,
    dialogTitle: 'Save $fileName',
  );
  return uri == null ? null : 'Saved $fileName';
}
