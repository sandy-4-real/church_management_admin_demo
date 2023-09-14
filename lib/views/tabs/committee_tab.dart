import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/models/committee_model.dart';
import 'package:church_management_admin/services/committee_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';

class CommitteeTab extends StatefulWidget {
  const CommitteeTab({super.key});

  @override
  State<CommitteeTab> createState() => _CommitteeTabState();
}

class _CommitteeTabState extends State<CommitteeTab> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController baptizeDateController = TextEditingController();
  TextEditingController marriageDateController = TextEditingController();
  TextEditingController socialStatusController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  File? profileImage;
  var uploadedImage;
  String? selectedImg;

  selectImage(){
    InputElement input = FileUploadInputElement()
    as InputElement
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: KText(
                text: "COMMITTEE",
                style: GoogleFonts.openSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Container(
              height: size.height * 1.51,
              width: 1100,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Constants().primaryAppColor,
                boxShadow: const [
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: "ADD COMMITTEE MEMBER",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 170,
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constants().primaryAppColor,
                                      width: 2),
                                  image: uploadedImage != null
                                      ? DecorationImage(
                                    fit: BoxFit.fill,
                                    image: MemoryImage(
                                      Uint8List.fromList(
                                        base64Decode(uploadedImage!.split(',').last),
                                      ),
                                    ),
                                  )
                                      : null),
                              child: uploadedImage == null
                                  ? const Center(
                                child: Icon(
                                  Icons.cloud_upload,
                                  size: 160,
                                  color: Colors.grey,
                                ),
                              ) : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: selectImage,
                                child: Container(
                                  height: 35,
                                  width: size.width * 0.25,
                                  color: Constants().primaryAppColor,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      KText(
                                        text: 'Select Profile Photo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Container(
                                height: 35,
                                width: size.width * 0.25,
                                color: Constants().primaryAppColor,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.crop,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    KText(
                                      text: 'Disable Crop',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Firstname",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: firstNameController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Lastname",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: lastNameController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Phone",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: phoneController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Email",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: emailController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Position",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: positionController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Baptize Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: baptizeDateController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Marriage Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: marriageDateController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Social Status",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: socialStatusController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Employment/Job",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: jobController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Family",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: familyController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Department",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: departmentController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Blood Group",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: bloodGroupController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Birth of Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: dobController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Nationality",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: nationalityController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (profileImage != null &&
                                      baptizeDateController.text != "" &&
                                      bloodGroupController.text != "" &&
                                      departmentController.text != "" &&
                                      dobController.text != "" &&
                                      emailController.text != "" &&
                                      familyController.text != "" &&
                                      firstNameController.text != "" &&
                                      jobController.text != "" &&
                                      lastNameController.text != "" &&
                                      marriageDateController.text != "" &&
                                      nationalityController.text != "" &&
                                      phoneController.text != "" &&
                                      positionController.text != "" &&
                                      socialStatusController.text != "") {
                                    Response response =
                                    await CommitteeFireCrud.addCommittee(
                                      image: profileImage!,
                                      baptizeDate: baptizeDateController.text,
                                      bloodGroup: bloodGroupController.text,
                                      department: departmentController.text,
                                      dob: dobController.text,
                                      email: emailController.text,
                                      family: familyController.text,
                                      firstName: firstNameController.text,
                                      job: jobController.text,
                                      lastName: lastNameController.text,
                                      marriageDate: marriageDateController.text,
                                      nationality: nationalityController.text,
                                      phone: phoneController.text,
                                      position: positionController.text,
                                      socialStatus: socialStatusController.text,
                                      country: countryController.text,
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Committee Member created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        uploadedImage = null;
                                        profileImage = null;
                                        baptizeDateController.text = "";
                                        bloodGroupController.text = "";
                                        departmentController.text = "";
                                        dobController.text = "";
                                        emailController.text = "";
                                        familyController.text = "";
                                        firstNameController.text = "";
                                        jobController.text = "";
                                        lastNameController.text = "";
                                        marriageDateController.text = "";
                                        nationalityController.text = "";
                                        phoneController.text = "";
                                        positionController.text = "";
                                        socialStatusController.text = "";
                                        countryController.text = "";
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Committee Member!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Center(
                                      child: KText(
                                        text: "ADD NOW",
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: 10,
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
            StreamBuilder(
              stream: CommitteeFireCrud.fetchCommitties(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<CommitteeModel> committies = snapshot.data!;
                  return Container(
                    width: 1100,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      boxShadow: const [
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Committee Members (${committies.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height:
                          size.height * 0.82 > 130 + committies.length * 210
                              ? 130 + committies.length * 210
                              : size.height * 0.82,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Color(0xfff5f5f5),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                                crossAxisCount: 3,
                                childAspectRatio: 9 / 9,
                              ),
                              itemCount: committies.length,
                              itemBuilder: (ctx, i) {
                                CommitteeModel data = committies[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 8),
                                  child: SizedBox(
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 70, left: 22, right: 22),
                                          child: Container(
                                            color: Colors.white,
                                            width: double.infinity,
                                            padding:
                                            const EdgeInsets.only(top: 70),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                KText(
                                                  text: data.position!,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                ),
                                                KText(
                                                  text:
                                                  "${data.firstName!} ${data.lastName!}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                KText(
                                                  text:
                                                  data.socialStatus!,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          viewPopup(committies[i]);
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          decoration: const BoxDecoration(
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
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: 6),
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  const Icon(
                                                                    Icons.remove_red_eye,
                                                                    color: Colors.white,
                                                                    size: 15,
                                                                  ),
                                                                  KText(
                                                                    text: "View",
                                                                    style: GoogleFonts.openSans(
                                                                      color: Colors.white,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            baptizeDateController.text = committies[i].baptizeDate!;
                                                            bloodGroupController.text = committies[i].bloodGroup!;
                                                            departmentController.text = committies[i].department!;
                                                            dobController.text = committies[i].dob!;
                                                            emailController.text = committies[i].email!;
                                                            familyController.text = committies[i].family!;
                                                            firstNameController.text = committies[i].firstName!;
                                                            jobController.text = committies[i].job!;
                                                            lastNameController.text = committies[i].lastName!;
                                                            marriageDateController.text = committies[i].marriageDate!;
                                                            nationalityController.text = committies[i].nationality!;
                                                            phoneController.text = committies[i].phone!;
                                                            positionController.text = committies[i].position!;
                                                            socialStatusController.text = committies[i].socialStatus!;
                                                            countryController.text = committies[i].country!;
                                                            selectedImg = committies[i].imgUrl;
                                                          });
                                                          editPopUp(committies[i], size);
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          decoration: const BoxDecoration(
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
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: 6),
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  const Icon(
                                                                    Icons.add,
                                                                    color: Colors.white,
                                                                    size: 15,
                                                                  ),
                                                                  KText(
                                                                    text: "Edit",
                                                                    style: GoogleFonts.openSans(
                                                                      color: Colors.white,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      InkWell(
                                                        onTap: () {
                                                          CoolAlert.show(
                                                              context: context,
                                                              type: CoolAlertType.info,
                                                              text: "${committies[i].firstName} ${committies[i].lastName} will be deleted",
                                                              title: "Delete this Record?",
                                                              width: size.width * 0.4,
                                                              backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                              showCancelBtn: true,
                                                              cancelBtnText: 'Cancel',
                                                              cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                              onConfirmBtnTap: () async {
                                                                Response res = await CommitteeFireCrud.deleteRecord(id: committies[i].id!);
                                                              }
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          decoration: const BoxDecoration(
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
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: 6),
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  const Icon(
                                                                    Icons.cancel_outlined,
                                                                    color: Colors.white,
                                                                    size: 15,
                                                                  ),
                                                                  KText(
                                                                    text: "Delete",
                                                                    style: GoogleFonts.openSans(
                                                                      color: Colors.white,
                                                                      fontSize: 10,
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
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 25,
                                          left: 10,
                                          right: 10,
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                Constants().primaryAppColor,
                                                image: data.imgUrl != null
                                                    ? DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: NetworkImage(
                                                        data.imgUrl!))
                                                    : null),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  viewPopup(CommitteeModel committee) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: const [
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          committee.firstName!,
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
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
                              const EdgeInsets.symmetric(horizontal: 6),
                              child: Center(
                                child: KText(
                                  text: "CLOSE",
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: size.width * 0.3,
                            height: size.height * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(committee.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        "${committee.firstName!} ${committee.lastName!}",
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Phone",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.phone!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Email",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.email!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Position",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.position!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Department",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.department!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Family",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.family!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Baptize Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.baptizeDate!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Social Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.socialStatus!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Marriage Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.marriageDate!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Employment/Job",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.job!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Blood Group",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.bloodGroup!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Birth of Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.dob!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Nationality",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        committee.nationality!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
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
      },
    );
  }

  editPopUp(CommitteeModel committee, Size size) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content:  Container(
            height: size.height * 1.51,
            width: 1100,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: const [
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "EDIT COMMITTEE MEMBER",
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              uploadedImage = null;
                              profileImage = null;
                              baptizeDateController.text = "";
                              bloodGroupController.text = "";
                              departmentController.text = "";
                              dobController.text = "";
                              emailController.text = "";
                              familyController.text = "";
                              firstNameController.text = "";
                              jobController.text = "";
                              lastNameController.text = "";
                              marriageDateController.text = "";
                              nationalityController.text = "";
                              phoneController.text = "";
                              positionController.text = "";
                              socialStatusController.text = "";
                              countryController.text = "";
                            });
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 170,
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constants().primaryAppColor,
                                      width: 2),
                                  image: selectedImg != null
                                      ? DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(selectedImg!))
                                      : uploadedImage != null
                                      ? DecorationImage(
                                    fit: BoxFit.fill,
                                    image: MemoryImage(
                                      Uint8List.fromList(
                                        base64Decode(uploadedImage!
                                            .split(',')
                                            .last),
                                      ),
                                    ),
                                  )
                                      : null),
                              child: selectedImg == null
                                  ? const Center(
                                child: Icon(
                                  Icons.cloud_upload,
                                  size: 160,
                                  color: Colors.grey,
                                ),
                              )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: selectImage,
                                child: Container(
                                  height: 35,
                                  width: size.width * 0.25,
                                  color: Constants().primaryAppColor,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      KText(
                                        text: 'Select Profile Photo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Container(
                                height: 35,
                                width: size.width * 0.25,
                                color: Constants().primaryAppColor,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.crop,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    KText(
                                      text: 'Disable Crop',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Firstname",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: firstNameController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Lastname",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: lastNameController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Phone",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: phoneController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Email",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: emailController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Position",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: positionController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Baptize Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: baptizeDateController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Marriage Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: marriageDateController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Social Status",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: socialStatusController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Employment/Job",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: jobController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Family",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: familyController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Department",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: departmentController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Blood Group",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: bloodGroupController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Birth of Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: dobController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Nationality",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: nationalityController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (
                                      baptizeDateController.text != "" &&
                                      bloodGroupController.text != "" &&
                                      departmentController.text != "" &&
                                      dobController.text != "" &&
                                      emailController.text != "" &&
                                      familyController.text != "" &&
                                      firstNameController.text != "" &&
                                      jobController.text != "" &&
                                      lastNameController.text != "" &&
                                      marriageDateController.text != "" &&
                                      nationalityController.text != "" &&
                                      phoneController.text != "" &&
                                      positionController.text != "" &&
                                      socialStatusController.text != "") {
                                    Response response =
                                    await CommitteeFireCrud.updateRecord(
                                      CommitteeModel(
                                        id: committee.id,timestamp: committee.timestamp,
                                        baptizeDate: baptizeDateController.text,
                                        bloodGroup: bloodGroupController.text,
                                        department: departmentController.text,
                                        dob: dobController.text,
                                        email: emailController.text,
                                        family: familyController.text,
                                        firstName: firstNameController.text,
                                        job: jobController.text,
                                        lastName: lastNameController.text,
                                        marriageDate: marriageDateController.text,
                                        nationality: nationalityController.text,
                                        phone: phoneController.text,
                                        position: positionController.text,
                                        socialStatus: socialStatusController.text,
                                        country: countryController.text,
                                      ),
                                        profileImage,
                                        committee.imgUrl ?? ""
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Committee Member updated successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        uploadedImage = null;
                                        profileImage = null;
                                        baptizeDateController.text = "";
                                        bloodGroupController.text = "";
                                        departmentController.text = "";
                                        dobController.text = "";
                                        emailController.text = "";
                                        familyController.text = "";
                                        firstNameController.text = "";
                                        jobController.text = "";
                                        lastNameController.text = "";
                                        marriageDateController.text = "";
                                        nationalityController.text = "";
                                        phoneController.text = "";
                                        positionController.text = "";
                                        socialStatusController.text = "";
                                        countryController.text = "";
                                      });
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to update Committee Member!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Center(
                                      child: KText(
                                        text: "Update",
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: 10,
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
      },
    );
  }


  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow: const [
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
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Please fill required fields !!',
                  style: TextStyle(color: Colors.black)),
            ),
            const Spacer(),
            TextButton(
                onPressed: () => debugPrint("Undid"), child: const Text("Undo"))
          ],
        )),
  );
}