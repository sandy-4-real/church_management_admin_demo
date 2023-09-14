import 'dart:typed_data';
import 'package:church_management_admin/models/members_model.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateMemberPdf(PdfPageFormat pageFormat,List<MembersModel> membersList ) async {

  final event = MemberModelforPdf(
      title: "Members",
      members: membersList
  );

  return await event.buildPdf(pageFormat);
}

class MemberModelforPdf{

  MemberModelforPdf({required this.title, required this.members});
  String? title;
  List<MembersModel> members = [];

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          _contentTable(context),
          pw.SizedBox(height: 20),
          pw.SizedBox(height: 20),
        ],
      ),
    );
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
    return doc.save();
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Si.NO',
      'Name',
      'Position',
      'Phone',
      'Country'
    ];

    return pw.
    TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        //color: PdfColors.teal
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: PdfColors.amber,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.black,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
            (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        members.length,
            (row) => List<String>.generate(
          tableHeaders.length,
              (col) => members[row].getIndex(col,row),
        ),
      ),
    );
  }
}