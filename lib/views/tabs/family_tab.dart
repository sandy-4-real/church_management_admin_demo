
import 'dart:convert';
import 'dart:html';

import 'package:church_management_admin/models/family_model.dart';
import 'package:church_management_admin/services/family_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';

class FamilyTab extends StatefulWidget {
   FamilyTab({super.key});

  @override
  State<FamilyTab> createState() => _FamilyTabState();
}

class _FamilyTabState extends State<FamilyTab> {

  TextEditingController familynameController = TextEditingController();
  TextEditingController familyleadernameController = TextEditingController();
  TextEditingController familynumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zoneController = TextEditingController();
  TextEditingController familyIdController = TextEditingController();
  int familyQuanity = 0;
  bool isCropped = false;
  TextEditingController filterTextController = TextEditingController();
  String filterText = "";

  String currentTab = 'View';

  setFamilyId() async {
    var document = await cf.FirebaseFirestore.instance.collection('Families').get();
    var churchDetails = await cf.FirebaseFirestore.instance.collection('ChurchDetails').get();
    String familyIdPrefix = churchDetails.docs.first.get("familyIdPrefix");
    int lastId = document.docs.length + 1;
    String familyId = lastId.toString();
    for(int i = 0; i < 5; i++) {
      if(familyId.length < 7){
        familyId = "0$familyId";
      }
    }
    setState((){
      familyIdController.text = familyIdPrefix+familyId;
    });
  }

  File? profileImage;
  var uploadedImage;
  String? selectedImg;

  selectImage() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      FileReader reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          profileImage = file;
        });
        setState(() {
          uploadedImage = reader.result;
          selectedImg = null;
        });
      });
      setState(() {});
    });
  }

  bool isEmail(String input) => EmailValidator.validate(input);
  final _key = GlobalKey<FormFieldState>();
  final _keyFamilyname = GlobalKey<FormFieldState>();
  final _keyFamilyLeadername = GlobalKey<FormFieldState>();
  final _keyPhone = GlobalKey<FormFieldState>();
  final _keyAddress = GlobalKey<FormFieldState>();
  final _keyZone = GlobalKey<FormFieldState>();
  bool profileImageValidator = false;

  bool isLoading = false;


  clearTextEditingControllers(){
    setState(() {
      currentTab = 'View';
      uploadedImage = null;
      profileImage = null;
      familynameController.text = "";
      familyleadernameController.text = "";
      familynumberController.text = "";
      familyQuanity = 0;
      cityController.text = "";
      emailController.text = "";
      addressController.text = "";
      countryController.text = "";
      zoneController.text = "";
      isLoading = false;
    });
  }


  final nameFocusNode = FocusNode();
  final leaderNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final countryFocusNode = FocusNode();
  final postFocusNode = FocusNode();

  @override
  void initState() {
    setFamilyId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: height/81.375,horizontal: width/170.75),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: width/170.75,
              vertical: height/81.375
            ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "FAMILIES",
                    style: GoogleFonts.openSans(
                        fontSize: width/52.538,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                  InkWell(
                      onTap:(){
                        if(currentTab.toUpperCase() == "VIEW") {
                          setState(() {
                            currentTab = "Add";
                          });
                        }else{
                          setState(() {
                            currentTab = 'View';
                          });
                          //clearTextControllers();
                        }
                      },
                      child: Container(
                        height: height/18.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                           EdgeInsets.symmetric(horizontal: width/227.66),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Family" : "View Families",
                              style: GoogleFonts.openSans(
                                fontSize: width/105.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
            currentTab.toUpperCase() == "ADD"
                ? Stack(
              alignment: Alignment.center,
                  children: [
                    Container(
              height: size.height * 1.85,
              width: double.infinity,
              margin:  EdgeInsets.symmetric(
                    horizontal: width/68.3,vertical: height/32.55
              ),
              decoration: BoxDecoration(
                    color: Constants().primaryAppColor,
                    boxShadow:  [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1, 2),
                        blurRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: size.height * 0.1,
                        width: double.infinity,
                        child: Padding(
                          padding:  EdgeInsets.symmetric(
                              horizontal: width/68.3, vertical: height/81.375),
                          child: Row(
                            children: [
                               Icon(Icons.group),
                               SizedBox(width:width/136.6),
                              KText(
                                text: "ADD FAMILY",
                                style: GoogleFonts.openSans(
                                  fontSize:width/68.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding:  EdgeInsets.symmetric(horizontal: width/68.5,vertical: height/32.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height:height/3.829,
                                  width: width/3.902,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants().primaryAppColor,
                                          width: width/683),
                                      image: uploadedImage != null
                                          ? DecorationImage(
                                        fit: isCropped ? BoxFit.contain : BoxFit.cover,
                                        image: MemoryImage(
                                          Uint8List.fromList(
                                            base64Decode(uploadedImage!
                                                .split(',')
                                                .last),
                                          ),
                                        ),
                                      )
                                          : null),
                                  child: uploadedImage == null
                                      ?  Center(
                                    child: Icon(
                                      Icons.cloud_upload,
                                      size: width/8.537,
                                      color: Colors.grey,
                                    ),
                                  )
                                      : null,
                                ),
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: selectImage,
                                    child: Container(
                                      height:height/18.6,
                                      width: size.width * 0.25,
                                      color: Constants().primaryAppColor,
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo,
                                              color: Constants().btnTextColor,),
                                          SizedBox(width:width/136.6),
                                          KText(
                                            text: 'Select Family Leader Photo *',
                                            style: TextStyle(color: Constants().btnTextColor,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: width/27.32),
                                  InkWell(
                                    onTap: (){
                                      if(isCropped){
                                        setState(() {
                                          isCropped = false;
                                        });
                                      }else{
                                        setState(() {
                                          isCropped = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height:height/18.6,
                                      width: size.width * 0.25,
                                      color: Constants().primaryAppColor,
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.crop,
                                            color: Constants().btnTextColor,
                                          ),
                                          SizedBox(width:width/136.6),
                                          KText(
                                            text: 'Disable Crop',
                                            style: TextStyle(color: Constants().btnTextColor,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family ID *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: familyIdController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Name/Title *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: nameFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(leaderNameFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(leaderNameFocusNode);
                                          },
                                          key: _keyFamilyname,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onChanged: (val){
                                          //  _keyFamilyname.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                          ],
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: familynameController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Leader Name *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: leaderNameFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(phoneFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(phoneFocusNode);
                                          },
                                          key: _keyFamilyLeadername,
                                          onChanged: (val){
                                           // _keyFamilyLeadername.currentState!.validate();
                                          },
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: familyleadernameController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        KText(
                                          text: "Family Members Count *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                             SizedBox(width:width/68.3),
                                            Text(
                                              familyQuanity.toString(),
                                              style:  TextStyle(
                                                fontSize:width/68.3,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      familyQuanity++;
                                                    });
                                                  },
                                                  child: Container(
                                                    height:height/21.7,
                                                    width:width/68.3,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        boxShadow:  [
                                                          BoxShadow(
                                                              color:
                                                                  Color(0xffc0c0c1),
                                                              offset: Offset(2, 3),
                                                              blurRadius: 3)
                                                        ]),
                                                    child:  Center(
                                                      child:
                                                          Icon(Icons.arrow_drop_up),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (familyQuanity >= 1) {
                                                      setState(() {
                                                        familyQuanity--;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height:height/21.7,
                                                    width:width/68.3,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        boxShadow:  [
                                                          BoxShadow(
                                                              color:
                                                                  Color(0xffc0c0c1),
                                                              offset: Offset(2, 3),
                                                              blurRadius: 3)
                                                        ]),
                                                    child:  Center(
                                                      child: Icon(
                                                          Icons.arrow_drop_down),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Contact Number *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/97.57,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: phoneFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(emailFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(emailFocusNode);
                                          },
                                          key: _keyPhone,
                                          validator: (val){
                                            if(val!.isEmpty) {
                                              return 'Field is required';
                                            } else if(val.length != 10){
                                              return 'number must be 10 digits';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onChanged: (val){
                                           // _keyPhone.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 10,
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: familynumberController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Email",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/97.57,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: emailFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                           // _key.currentState!.validate();
                                            FocusScope.of(context).requestFocus(addressFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(addressFocusNode);
                                          },
                                          key: _key,
                                          validator: (value) {
                                            if (!isEmail(value!)) {
                                              return 'Please enter a valid email.';
                                            }
                                            return null;
                                          },
                                          onChanged: (val){
                                            //_key.currentState!.validate();
                                          },
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: emailController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Residential Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin:  EdgeInsets.symmetric(
                                      vertical: height/32.55,
                                      horizontal: width/68.3
                                    ),
                                    decoration: BoxDecoration(
                                      color: Constants().primaryAppColor,
                                      boxShadow:  [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                         SizedBox(
                                          height:height/32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            decoration:  BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: TextFormField(
                                              focusNode: addressFocusNode,
                                              autofocus: true,
                                              onEditingComplete: (){
                                                FocusScope.of(context).requestFocus(cityFocusNode);
                                              },
                                              onFieldSubmitted: (val){
                                                FocusScope.of(context).requestFocus(cityFocusNode);
                                              },
                                              key: _keyAddress,
                                              validator: (val){
                                                if(val!.isEmpty){
                                                  return 'Field is required';
                                                }else{
                                                  return '';
                                                }
                                              },
                                              onChanged: (val){
                                               // _keyAddress.currentState!.validate();
                                              },
                                              maxLength: 255,
                                              maxLines: null,
                                                style:  TextStyle(fontSize:width/113.83),
                                                controller: addressController,
                                              decoration:  InputDecoration(
                                                counterText: '',
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: width/91.06,top: height/162.75,bottom: height/162.75)
                                              ),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Permanent Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin:  EdgeInsets.symmetric(
                                        vertical: height/32.55,
                                        horizontal: width/68.3
                                    ),
                                    decoration: BoxDecoration(
                                      color: Constants().primaryAppColor,
                                      boxShadow:  [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height:height/32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration:  BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return '';
                                                  }
                                                },
                                                maxLength: 255,
                                                maxLines: null,
                                                style:  TextStyle(fontSize:width/113.83),
                                                controller: permanentAddressController,
                                                decoration:  InputDecoration(
                                                    counterText: '',
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(left: width/91.06,top: height/162.75,bottom: height/162.75)
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width:width/6.830,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "City",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: cityFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(countryFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(countryFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: cityController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/6.830,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Country",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: countryFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(postFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(postFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: countryController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/6.830,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Postal/Zone *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: postFocusNode,
                                          autofocus: true,
                                          key: _keyZone,
                                          validator: (val){
                                            if(val!.length != 6){
                                              return 'Must be 6 digits';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onChanged: (val){
                                            //_keyZone.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 6,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: zoneController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if(!isLoading){
                                        setState((){
                                          isLoading = true;
                                        });
                                        _keyFamilyname.currentState!.validate();
                                        _keyFamilyLeadername.currentState!.validate();
                                        _keyPhone.currentState!.validate();
                                        //_keyAddress.currentState!.validate();
                                        _keyZone.currentState!.validate();
                                        if (
                                        profileImage != null &&
                                            familynameController.text != "" &&
                                            familyleadernameController.text != "" &&
                                            familynumberController.text != "" &&
                                            familynumberController.text.length == 10 &&
                                            zoneController.text.length == 6 &&
                                            familyIdController.text != "" &&
                                            familyQuanity != 0 &&
                                            zoneController.text != "") {
                                          Response response =  await FamilyFireCrud.addFamily(
                                              permanentAddress: permanentAddressController.text,
                                              image: profileImage,
                                              familyId: familyIdController.text,
                                              name: familynameController.text,
                                              email: emailController.text,
                                              leaderName: familyleadernameController.text,
                                              contactNumber: familynumberController.text,
                                              city: cityController.text,
                                              zone: zoneController.text,
                                              address: addressController.text,
                                              country: countryController.text,
                                              quantity: familyQuanity
                                          );
                                          if (response.code == 200) {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.success,
                                                text: "Family created successfully!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
                                            );
                                            setFamilyId();
                                            clearTextEditingControllers();
                                          } else {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: "Failed to Create Family!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height:height/18.6,
                                      width:width*0.1,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow:  [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                         EdgeInsets.symmetric(horizontal:width/227.66),
                                        child: Center(
                                          child: KText(
                                            text: "ADD NOW",
                                            style: GoogleFonts.openSans(
                                              color: Constants().btnTextColor,
                                              fontSize:width/136.6,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
              ),
            ),
                    Visibility(
                      visible: isLoading,
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                        ),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                          width: size.width/1.37,
                          alignment: AlignmentDirectional.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: SizedBox(
                                    height: height/1.86,
                                    width: width/2.732,
                                    child: Lottie.asset("assets/loadinganim.json")
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25.0),
                                child: Center(
                                  child: Text(
                                    "loading..Please wait...",
                                    style: TextStyle(
                                      fontSize: width/56.91666666666667,
                                      color: Constants().primaryAppColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
                : currentTab.toUpperCase() == "VIEW" ? StreamBuilder(
              stream: FamilyFireCrud.fetchFamilies(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<FamilyModel> families = [];
                  List<FamilyModel> families1 = snapshot.data!;
                  for (var element in families1) {
                    if(filterText != ""){
                      if(element.zone!.toLowerCase().startsWith(filterText.toLowerCase())||
                          element.name!.toLowerCase().startsWith(filterText.toLowerCase())||
                          element.contactNumber!.toLowerCase().startsWith(filterText.toLowerCase())
                      ){
                        families.add(element);
                      }
                    }else{
                      families.add(element);
                    }
                  }
                  return
                    Container(
                    width: width/1.241,
                    margin:  EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3),
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      boxShadow:  [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal:width/68.3, vertical:height/81.375),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "ALL Families (${families.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Material(
                                  borderRadius:
                                  BorderRadius.circular(5),
                                  color: Colors.white,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: height / 18.6,
                                    width: width / 5.106,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 81.375,
                                          horizontal: width / 170.75),
                                      child: TextField(
                                        controller:
                                        filterTextController,
                                        onChanged: (val) {
                                          setState(() {
                                            filterText = val;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                          "Search by Name,Phone,Pincode",
                                          hintStyle:
                                          GoogleFonts.openSans(
                                            fontSize: width/97.571,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.73,
                          width: double.infinity,
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                           padding:  EdgeInsets.symmetric(horizontal: width/68.5,vertical: height/32.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:width/17.075,
                                      child: KText(
                                        text: "No.",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.076,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/7.588,
                                      child: KText(
                                        text: "Family Name/Title",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/7.588,
                                      child: KText(
                                        text: "Family Leader Name",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/11.035,
                                      child: KText(
                                        text: "Family Count",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.076,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/8.830,
                                      child: KText(
                                        text: "Contact Number",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.076,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/8.830,
                                      child: KText(
                                        text: "Status",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.076,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/9.106,
                                      child: KText(
                                        text: "Actions",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.076,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                               SizedBox(height: height/65.1),
                              Expanded(
                                child: ListView.builder(
                                 // physics: NeverScrollableScrollPhysics(),
                                  itemCount: families.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: height/7.233,
                                      width: double.infinity,
                                      decoration:  BoxDecoration(
                                        //color: Colors.white,
                                        border: Border(
                                          top: BorderSide(
                                            color: const Color(0xfff1f1f1),
                                            width: width/1366,
                                          ),
                                          bottom: BorderSide(
                                            color: const Color(0xfff1f1f1),
                                            width: width/1366,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/17.075,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/7.588,
                                            child: KText(
                                              text: families[i].name!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/7.588,
                                            child: KText(
                                              text: families[i].leaderName!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/10.035,
                                            child: KText(
                                              text: families[i].quantity!.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/12.830,
                                            child: KText(
                                              text: families[i].contactNumber!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/10.830,
                                            child: FlutterSwitch(
                                              width: 65,
                                              height: 32,
                                              valueFontSize: 11,
                                              toggleSize: 0,
                                              //value: users[i].user.status!,
                                              value: families[i].status!,
                                              borderRadius: 30,
                                              padding: 8.0,
                                              showOnOff: true,
                                              activeColor: Colors.green,
                                              activeText: "Active",
                                              inactiveColor: Colors.red,
                                              inactiveText: "Inactive",
                                              activeToggleColor: Colors.green,
                                              inactiveToggleColor: Colors.red,
                                              onToggle: (val) {
                                                String statsu = !val ? "Inactive" : "Active";
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.info,
                                                    text: "${families[i].name!}'s status will be $statsu",
                                                    title: "Update this Record?",
                                                    width: size.width * 0.4,
                                                    backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                    showCancelBtn: true,
                                                    cancelBtnText: 'Cancel',
                                                    cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                    onConfirmBtnTap: () async {
                                                      await updateFamilyStatus(families[i].id!, val);
                                                    }
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                              width:width/7.588,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(families[i]);
                                                    },
                                                    child: Container(
                                                      height:height/26.04,
                                                      decoration:  BoxDecoration(
                                                        color: Color(0xff2baae4),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            offset: Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:  EdgeInsets.symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                               Icon(
                                                                Icons.remove_red_eye,
                                                                color: Colors.white,
                                                                size:width/91.066,
                                                              ),
                                                              KText(
                                                                text: "View",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize:width/136.6,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: width/273.2),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        familynameController.text = families[i].name!;
                                                        familyleadernameController.text = families[i].leaderName!;
                                                        familyQuanity = families[i].quantity!;
                                                        familynumberController.text = families[i].contactNumber!;
                                                        addressController.text = families[i].address!;
                                                        cityController.text = families[i].city!;
                                                        emailController.text = families[i].email!;
                                                        countryController.text = families[i].country!;
                                                        zoneController.text = families[i].zone!;
                                                        familyIdController.text = families[i].familyId!;
                                                        permanentAddressController.text = families[i].permanentAddress!;
                                                      });
                                                      editPopUp(families[i],size);
                                                    },
                                                    child: Container(
                                                      height:height/26.04,
                                                      decoration:  BoxDecoration(
                                                        color: Color(0xffff9700),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            offset: Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:  EdgeInsets.symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                               Icon(
                                                                Icons.add,
                                                                color: Colors.white,
                                                                size:width/91.066,
                                                              ),
                                                              KText(
                                                                text: "Edit",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize:width/136.6,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                   SizedBox(width: width/273.2),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.info,
                                                          text: "${families[i].name} will be deleted",
                                                          title: "Delete this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                          onConfirmBtnTap: () async {
                                                            Response res = await FamilyFireCrud.deleteRecord(id: families[i].id!);
                                                            setFamilyId();
                                                          }
                                                      );
                                                    },
                                                    child: Container(
                                                      height:height/26.04,
                                                      decoration:  BoxDecoration(
                                                        color: Color(0xfff44236),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            offset: Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:  EdgeInsets.symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                               Icon(
                                                                Icons.cancel_outlined,
                                                                color: Colors.white,
                                                                size:width/91.066,
                                                              ),
                                                              KText(
                                                                text: "Delete",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize:width/136.6,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ) : Container(),
            SizedBox(height: size.height * 0.04),
            const DeveloperCardWidget(),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  viewPopup(FamilyModel family) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
            margin:  EdgeInsets.symmetric(
                                  vertical: height/32.55,
                                  horizontal: width/68.3
                                ),
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow:  [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Padding(
                    padding:
                     EdgeInsets.symmetric(horizontal:width/68.3, vertical:height/81.375),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          family.name!,
                          style: GoogleFonts.openSans(
                            fontSize:width/68.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: height/16.275,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow:  [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                               EdgeInsets.symmetric(horizontal:width/227.66),
                              child: Center(
                                child: KText(
                                  text: "CLOSE",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/85.375,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: width/136.6, vertical: height/43.4),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                height: size.height * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(family.leaderImgUrl!),
                                  ),
                                ),
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Family ID",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.familyId!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
                                    ),
                                  )
                                ],
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.name!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
                                    ),
                                  )
                                ],
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.email!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
                                    ),
                                  )
                                ],
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Leader Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.leaderName!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
                                    ),
                                  )
                                ],
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Family members count",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.quantity!.toString(),
                                    style:  TextStyle(
                                        fontSize:width/97.57
                                    ),
                                  )
                                ],
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Contact Number",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.contactNumber!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Residential Address",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: KText(
                                      text: family.address!,
                                      style:  TextStyle(
                                          fontSize:width/97.57
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height:height/32.55),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Permanent Address",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                  Text(":"),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: KText(
                                      text: family.permanentAddress!,
                                      style:  TextStyle(
                                          fontSize:width/97.57
                                      ),
                                    )
                                  ),
                                ],
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "City",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.city!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Post/Zone",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.zone!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Country",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize:width/85.375
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.country!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/32.55),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  updateFamilyStatus(String docId,bool status) async {
    cf.FirebaseFirestore.instance.collection('Families').doc(docId).update({
      "status" : status,
    });
  }

  editPopUp(FamilyModel family, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: size.height * 0.95,
                width: double.infinity,
                margin:  EdgeInsets.symmetric(
                                      vertical: height/32.55,
                                      horizontal: width/68.3
                                    ),
                decoration: BoxDecoration(
                  color: Constants().primaryAppColor,
                  boxShadow:  [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1, 2),
                      blurRadius: 3,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: width/68.3, vertical:height/81.375),
                        child: Row(
                          children: [
                             Icon(Icons.group),
                             SizedBox(width:width/136.6),
                            KText(
                              text: "EDIT FAMILY",
                              style: GoogleFonts.openSans(
                                fontSize:width/68.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             Expanded(child: SizedBox()),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  uploadedImage = null;
                                  profileImage = null;
                                  familynameController.text = "";
                                  familyleadernameController.text = "";
                                  familynumberController.text = "";
                                  familyQuanity = 0;
                                  cityController.text = "";
                                  emailController.text = "";
                                  addressController.text = "";
                                  countryController.text = "";
                                  zoneController.text = "";
                                });
                                Navigator.pop(context);
                              },
                              child:  Icon(Icons.cancel_outlined),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        padding:  EdgeInsets.symmetric(vertical: height/32.55,horizontal: width/68.3),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family ID",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: familyIdController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Name/Title",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                          ],
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: familynameController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Leader Name",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: familyleadernameController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        KText(
                                          text: "Family Members Quantity",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                             SizedBox(width:width/68.3),
                                            Text(
                                              family.quantity.toString(),
                                              style:  TextStyle(
                                                fontSize:width/68.3,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      family.quantity = family.quantity! + 1;
                                                    });
                                                  },
                                                  child: Container(
                                                    height:height/21.7,
                                                    width:width/68.3,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                        boxShadow:  [
                                                          BoxShadow(
                                                              color:
                                                              Color(0xffc0c0c1),
                                                              offset: Offset(2, 3),
                                                              blurRadius: 3)
                                                        ]),
                                                    child:  Center(
                                                      child:
                                                      Icon(Icons.arrow_drop_up),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (family.quantity! >= 1) {
                                                      setState(() {
                                                        family.quantity = family.quantity! - 1;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height:height/21.7,
                                                    width:width/68.3,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                        boxShadow:  [
                                                          BoxShadow(
                                                              color:
                                                              Color(0xffc0c0c1),
                                                              offset: Offset(2, 3),
                                                              blurRadius: 3)
                                                        ]),
                                                    child:  Center(
                                                      child: Icon(
                                                          Icons.arrow_drop_down),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Contact Number",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/97.57,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 10,
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: familynumberController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Email",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/97.57,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          key: _key,
                                          validator: (value) {
                                            if (!isEmail(value!)) {
                                              return 'Please enter a valid email.';
                                            }
                                            return null;
                                          },
                                          onEditingComplete: (){
                                            _key.currentState!.validate();
                                          },
                                          onChanged: (val){
                                            _key.currentState!.validate();
                                          },
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: emailController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/6.830,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "City",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: cityController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/6.830,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Country",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: countryController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/6.830,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Postal/Zone",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 6,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: zoneController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Residential Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin:  EdgeInsets.symmetric(
                                      vertical: height/32.55,
                                      horizontal: width/68.3
                                    ),
                                    decoration: BoxDecoration(
                                      color: Constants().primaryAppColor,
                                      boxShadow:  [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                         SizedBox(
                                          height:height/32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration:  BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                maxLength: 255,
                                                maxLines: null,
                                                style:  TextStyle(fontSize:width/113.83),
                                                controller: addressController,
                                                decoration:  InputDecoration(
                                                  counterText: '',
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(left: width/91.06,
                                                        top: height/162.75,bottom: height/162.75)
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Permanent Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin:  EdgeInsets.symmetric(
                                        vertical: height/32.55,
                                        horizontal: width/68.3
                                    ),
                                    decoration: BoxDecoration(
                                      color: Constants().primaryAppColor,
                                      boxShadow:  [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height:height/32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration:  BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return '';
                                                  }
                                                },
                                                maxLength: 255,
                                                maxLines: null,
                                                style:  TextStyle(fontSize:width/113.83),
                                                controller: permanentAddressController,
                                                decoration:  InputDecoration(
                                                    counterText: '',
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(left: width/91.06,top: height/162.75,bottom: height/162.75)
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (true) {
                                        Response response =  await FamilyFireCrud.updateRecord(
                                            FamilyModel(
                                              id: family.id,
                                                timestamp: family.timestamp,
                                                familyId: family.familyId,
                                                name: familynameController.text,
                                                leaderName: familyleadernameController.text,
                                                contactNumber: familynumberController.text,
                                                city: cityController.text,
                                                email: emailController.text,
                                                status: family.status,
                                                zone: zoneController.text,
                                                address: addressController.text,
                                                permanentAddress: permanentAddressController.text,
                                                country: countryController.text,
                                                quantity: family.quantity,
                                            ),
                                            profileImage,
                                            family.leaderImgUrl ?? ""
                                        );
                                        if (response.code == 200) {
                                         await CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "Family updated successfully!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
                                          );
                                          setState(() {
                                            uploadedImage = null;
                                            profileImage = null;
                                            familynameController.text = "";
                                            familyleadernameController.text = "";
                                            familynumberController.text = "";
                                            familyQuanity = 0;
                                            cityController.text = "";
                                            emailController.text = "";
                                            addressController.text = "";
                                            permanentAddressController.text = "";
                                            countryController.text = "";
                                            zoneController.text = "";
                                          });
                                          setFamilyId();
                                          Navigator.pop(context);
                                        } else {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Failed to update Family!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
                                          );
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    child: Container(
                                      height:height/18.6,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow:  [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                         EdgeInsets.symmetric(horizontal:width/227.66),
                                        child: Center(
                                          child: KText(
                                            text: "Update",
                                            style: GoogleFonts.openSans(
                                              color: Constants().btnTextColor,
                                              fontSize:width/136.6,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }


  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding:  EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow:  [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Constants().primaryAppColor),
             Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text('Please fill required fields !!',
                  style: TextStyle(color: Colors.black)),
            ),
             Spacer(),
            TextButton(
                onPressed: () => debugPrint("Undid"), child:  Text("Undo"))
          ],
        )),
  );
}
