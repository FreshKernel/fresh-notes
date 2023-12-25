import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DeltaToPDF {
  /// [Description]  converts header text style
  /// [Returns] fontWeight & fontSize
  (pw.FontWeight, double)? getPDFHeaderStyle(int value) {
    return switch (value) {
      1 => (pw.FontWeight.bold, 24),
      2 => (pw.FontWeight.bold, 20),
      3 => (pw.FontWeight.bold, 16),
      int() => (pw.FontWeight.normal, 14),
    };
  }

  /// [Description]  converts header attributed text style
  /// [Returns] fontWeight & fontSize
  List<Object> getHeaderAttributedText(
    Map<String, dynamic>? attribute,
    String text,
    bool hasAttribute,
  ) {
    pw.FontWeight fontWeight = pw.FontWeight.normal;
    double fontSize = 14;

    if (hasAttribute) {
      attribute!.forEach((key, value) {
        switch (key) {
          case 'header':
            if (value == 1) {
              fontWeight = pw.FontWeight.bold;
              fontSize = 18;
            } else if (value == 2) {
              fontWeight = pw.FontWeight.bold;
              fontSize = 16;
            } else {
              fontWeight = pw.FontWeight.bold;
              fontSize = 12;
            }
            break;
        }
      });
    }
    return [fontWeight, fontSize];
  }

  /// [Description]  converts header attributed text
  /// [Returns] all text with style
  pw.Text getAttributedText(
    String value,
    Map<String, dynamic>? attributes,
  ) {
    PdfColor fontColor = PdfColor.fromHex('#000');
    pw.FontStyle fontStyle = pw.FontStyle.normal;
    pw.FontWeight fontWeight = pw.FontWeight.normal;
    double? fontSize;
    pw.TextDecoration decoration = pw.TextDecoration.none;
    pw.BoxDecoration boxDecoration = const pw.BoxDecoration();
    pw.TextAlign? textAlign;

    attributes?.forEach((key, value) {
      switch (key) {
        // TODO: Fix
        case 'header':
          fontWeight = pw.FontWeight.bold;
          fontSize = switch (value) {
            1 => 34,
            2 => 30,
            3 => 24,
            4 => 20,
            5 => 18,
            6 => 16,
            Object() => null,
            null => null,
          };

          break;
        case 'align':
          textAlign = switch (value) {
            'center' => pw.TextAlign.center,
            'right' => pw.TextAlign.right,
            'left' => pw.TextAlign.left,
            'justify' => null,
            Object() => null,
            null => null,
          };
          break;
        case 'color':
          fontColor = PdfColor.fromHex(value);
          break;
        case 'bold':
          if (value == true) {
            fontWeight = pw.FontWeight.bold;
          }
          break;
        case 'italic':
          if (value == true) {
            fontStyle = pw.FontStyle.italic;
          }
          break;
        case 'underline':
          if (value == true) {
            decoration = pw.TextDecoration.underline;
          }
          break;
        case 'strike':
          if (value == true) {
            decoration = pw.TextDecoration.lineThrough;
          }
          break;
        case 'background':
          boxDecoration = pw.BoxDecoration(color: PdfColor.fromHex(value));
          break;
        case 'size':
          fontSize = double.tryParse(value);
          break;
      }
    });
    return pw.Text(
      value,
      textAlign: textAlign,
      style: pw.TextStyle(
        color: fontColor,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        decoration: decoration,
        background: boxDecoration,
        fontFallback: [
          pw.Font.symbol(),
        ],
      ),
    );
  }

  /// [Description]  main wrapper to convert delta to pdf
  /// [Returns] pdf widget object
  Future<pw.Column> deltaToPDF(Delta delta) async {
    final children = <pw.Widget>[];
    for (final operation in delta.operations) {
      if (!operation.isInsert) {
        continue;
      }
      final insertData = operation.data;
      if (insertData == null) {
        continue;
      }
      if (insertData is Map) {
        if (insertData.containsKey(fq.BlockEmbed.imageType)) {
          final imageData = insertData[fq.BlockEmbed.imageType] as String;
          final base64 = await convertImageToUint8List(imageData) ??
              (throw ArgumentError('The base 64 is null'));
          children.add(pw.Image(pw.MemoryImage(base64)));
        }
        continue;
      }

      children.add(
        getAttributedText(
          insertData.toString(),
          operation.attributes,
        ),
      );
    }
    return pw.Column(
      children: children,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
    );
  }
}
