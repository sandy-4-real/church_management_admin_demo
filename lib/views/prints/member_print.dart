import 'dart:typed_data';
import 'package:church_management_admin/models/members_model.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateMemberPdf(PdfPageFormat pageFormat,List<MembersModel> membersList, bool isPdf) async {

  final event = MemberModelforPdf(
      title: "Members",
      members: membersList
  );

  return await event.buildPdf(pageFormat,isPdf);
}

class MemberModelforPdf{

  MemberModelforPdf({required this.title, required this.members});
  String? title;
  List<MembersModel> members = [];

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat, bool isPdf) async {

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        build: (context) => [
          _contentTable(context),
        ],
      ),
    );
    if(!isPdf){
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
    }
    return doc.save();
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Si.NO',
      'Member ID',
      'Name',
      'Position',
      'Phone',
      'Pin Code'
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
      cellPadding: pw.EdgeInsets.zero,
      headerPadding: pw.EdgeInsets.zero,
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
      headers: List<pw.Widget>.generate(
        tableHeaders.length,
            (col) => pw.Container(
              // width: 60,
                height:40,
                decoration:pw.BoxDecoration(
                    border: pw.Border.all(color:PdfColors.black)
                ),
                child:  pw.Center(child:pw.Text(tableHeaders[col],style: pw.TextStyle(fontWeight: pw.FontWeight.bold,color: PdfColor.fromHex("E7B41F"))),)
            ),
      ),
      data: List<List<pw.Widget>>.generate(
        members.length,
            (row) => List<pw.Widget>.generate(
          tableHeaders.length,
              (col) => pw.Container(
                // width: 60,
                  height:40,
                  decoration:pw.BoxDecoration(
                      border: pw.Border.all(color:PdfColors.black)
                  ),
                  child:  pw.Center(child:pw.Text(members[row].getIndex(col,row),style: pw.TextStyle()),)
              ),
        ),
      ),
    );
  }
}