import 'dart:html';
import 'package:church_management_admin/models/committee_model.dart';
import 'package:church_management_admin/models/members_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference CommitteeCollection = firestore.collection('Committee');
final FirebaseStorage fs = FirebaseStorage.instance;

class CommitteeFireCrud {
  static Stream<List<CommitteeModel>> fetchCommitties() => CommitteeCollection
      .orderBy("timestamp", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => CommitteeModel.fromJson(doc.data() as Map<String,dynamic>))
      .toList());

  static Future<Response> addCommittee(
      {required File image,
        required String baptizeDate,
        required String bloodGroup,
        required String department,
        required String dob,
        required String country,
        required String email,
        required String family,
        required String firstName,
        required String job,
        required String lastName,
        required String marriageDate,
        required String nationality,
        required String phone,
        required String position,
        required String socialStatus}) async {
    String downloadUrl = await uploadImageToStorage(image);
    Response response = Response();
    DocumentReference documentReferencer = CommitteeCollection.doc();
    CommitteeModel committee = CommitteeModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        socialStatus: socialStatus,
        position: position,
        phone: phone,
        nationality: nationality,
        marriageDate: marriageDate,
        lastName: lastName,
        country: country,
        job: job,
        firstName: firstName,
        family: family,
        email: email,
        dob: dob,
        department: department,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        imgUrl: downloadUrl);
    committee.id = documentReferencer.id;
    var json = committee.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<String> uploadImageToStorage(file) async {
    var snapshot = await fs
        .ref()
        .child('dailyupdates')
        .child("${file.name}")
        .putBlob(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<Response> updateRecord(CommitteeModel committee,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      committee.imgUrl = downloadUrl;
    }else{
      committee.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = CommitteeCollection.doc(committee.id);
    var result = await documentReferencer.update(committee.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = CommitteeCollection.doc(id);
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
