import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/attendance_for_family_model.dart';

Future<Uint8List> generateAttendanceforFamilyPdf(PdfPageFormat pageFormat,List<AttendanceFamilyRecordModel> attenancesList, bool isPdf) async {

  final chorus = AttendanceFamilyModelforPdf(
      title: "Attendance",
      attenancesList: attenancesList
  );

  return await chorus.buildPdf(pageFormat,isPdf);
}

class AttendanceFamilyModelforPdf{

  AttendanceFamilyModelforPdf({required this.title, required this.attenancesList});
  String? title;
  List<AttendanceFamilyRecordModel> attenancesList = [];

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat,bool isPdf) async {

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        build: (context) => [
          pw.ListView.builder(
              itemCount: attenancesList.length,
              itemBuilder: (ctx,i){
                return pw.Container(
                    margin: const pw.EdgeInsets.symmetric(vertical: 10),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(vertical: 10),
                              child:  pw.Text("Date : ${attenancesList[i].date!}")
                          ),
                          _contentTable(context,attenancesList[i].attendance!),
                        ]
                    )
                );
              }
          ),
        ],
      ),
    );
    if(!isPdf) {
      Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
      );
    }
    return doc.save();
  }

  pw.Widget _contentTable(pw.Context context,List<AttendanceFamily> attenances) {
    const tableHeaders = [
      'Si.NO',
      'Member Id',
      'Member Name',
      'Attendance'
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
      cellPadding: pw.EdgeInsets.zero,
      headerPadding: pw.EdgeInsets.zero,
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
        attenances.length,
            (row) => List<pw.Widget>.generate(
          tableHeaders.length,
              (col) => pw.Container(
                // width: 60,
                  height:40,
                  decoration:pw.BoxDecoration(
                      border: pw.Border.all(color:PdfColors.black)
                  ),
                  child:  pw.Center(child:pw.Text(attenances[row].getIndex(col,row),style: pw.TextStyle()),)
              ),
        ),
      ),
    );
  }
}