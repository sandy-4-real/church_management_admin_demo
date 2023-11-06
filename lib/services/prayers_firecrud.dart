import 'package:church_management_admin/models/prayers_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference PrayerCollection = firestore.collection('Prayers');

class PrayersFireCrud {

  static Stream<List<PrayersModel>> fetchPrayers() => PrayerCollection.orderBy("timestamp",descending: true)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) =>
          PrayersModel.fromJson(doc.data() as Map<String,dynamic>)).toList()
  );

  static Stream<List<PrayersModel>> fetchPrayersWithFilter(DateTime start, DateTime end) =>
      PrayerCollection
          .orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['timestamp'] < end.add(const Duration(days: 1)).millisecondsSinceEpoch && element['timestamp'] >= start.millisecondsSinceEpoch)
          .map((doc) => PrayersModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addPrayer({
    required String title,
    required String date,
    required String time,
    required String description,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = PrayerCollection.doc();
    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(date);
    PrayersModel prayer = PrayersModel(
      title : title,
      id: "",
      date: date,
      time: time,
      description: description,
      timestamp : tempDate.millisecondsSinceEpoch,
      phone: '',
      requestedBy: 'Church',
      status: 'Pending',
    );
    prayer.id = documentReferencer.id;
    var json = prayer.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> updateRecord(PrayersModel prayer) async {
    Response res = Response();
    DocumentReference documentReferencer = PrayerCollection.doc(prayer.id);
    var result = await documentReferencer.update(prayer.toJson()).whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Updated from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }

  static Future<Response> deleteRecord({required String id}) async {
    Response res = Response();
    DocumentReference documentReferencer = PrayerCollection.doc(id);
    var result = await documentReferencer.delete().whenComplete((){
      res.code = 200;
      res.message = "Sucessfully Deleted from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }

}