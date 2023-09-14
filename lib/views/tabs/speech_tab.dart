import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/models/speech_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../services/speech_firecrud.dart';
import '../../widgets/kText.dart';

class SpeechTab extends StatefulWidget {
  const SpeechTab({super.key});

  @override
  State<SpeechTab> createState() => _SpeechTabState();
}

class _SpeechTabState extends State<SpeechTab> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController speechController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController googleplusController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController pinterestController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();

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
                text: "SPEECH",
                style: GoogleFonts.openSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Container(
              height: size.height * 1.05,
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
                            text: "ADD SPEECH",
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
                                              base64Decode(uploadedImage!
                                                  .split(',')
                                                  .last),
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
                              const SizedBox(width: 20),
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
                            ],
                          ),
                          const SizedBox(height: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Speech",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
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
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:
                                                const TextStyle(fontSize: 12),
                                            controller: speechController,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: 15,top: 4,bottom: 4)
                                            ),
                                            maxLines: null,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Facebook",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: facebookController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Twitter",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: twitterController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Google+",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: googleplusController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Linkedin",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: linkedinController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 30),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Youtube",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: youtubeController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Pinterest",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: pinterestController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Instagram",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: instagramController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Whatsapp",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: whatsappController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (profileImage != null &&
                                      firstNameController.text != "" &&
                                      lastNameController.text != "" &&
                                      positionController.text != "" &&
                                      speechController.text != ""
                                      // facebookController.text != "" &&
                                      // twitterController.text != "" &&
                                      // googleplusController.text != "" &&
                                      // linkedinController.text != "" &&
                                      // pinterestController.text != "" &&
                                      // youtubeController.text != "" &&
                                      // instagramController.text != "" &&
                                      // whatsappController.text != ""
                                  ) {
                                    Response response =
                                        await SpeechFireCrud.addSpeech(
                                      image: profileImage!,
                                      linkedin: linkedinController.text,
                                      pinterest: pinterestController.text,
                                      speech: speechController.text,
                                      twitter: twitterController.text,
                                      whatsapp: whatsappController.text,
                                      youtube: youtubeController.text,
                                      instagram: instagramController.text,
                                      google: googleplusController.text,
                                      facebook: facebookController.text,
                                      position: positionController.text,
                                      lastName: lastNameController.text,
                                      firstName: firstNameController.text,
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Speech created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        uploadedImage = null;
                                        profileImage = null;
                                        linkedinController.text == "";
                                        pinterestController.text == "";
                                        speechController.text == "";
                                        twitterController.text == "";
                                        whatsappController.text == "";
                                        youtubeController.text == "";
                                        instagramController.text == "";
                                        googleplusController.text == "";
                                        facebookController.text == "";
                                        positionController.text == "";
                                        lastNameController.text == "";
                                        firstNameController.text == "";
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Speech!",
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
              stream: SpeechFireCrud.fetchSpeechList(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<SpeechModel> speechList = snapshot.data!;
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
                                  text: "All Speeches (${speechList.length})",
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
                              size.height * 0.82 > 230 + speechList.length * 80
                                  ? 230 + speechList.length * 80
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
                              itemCount: speechList.length,
                              itemBuilder: (ctx, i) {
                                SpeechModel data = speechList[i];
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
                                                SizedBox(
                                                  height: 60,
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: KText(
                                                      text:
                                                      data.speech!,
                                                      style: const TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          viewPopup(speechList[i]);
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
                                                            firstNameController.text = speechList[i].firstName!;
                                                            lastNameController.text = speechList[i].lastName!;
                                                            positionController.text = speechList[i].position!;
                                                            speechController.text = speechList[i].speech!;
                                                            selectedImg = speechList[i].imgUrl;
                                                          });
                                                          editPopUp(speechList[i], size);
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
                                                              text: "${speechList[i].firstName} ${speechList[i].lastName} will be deleted",
                                                              title: "Delete this Record?",
                                                              width: size.width * 0.4,
                                                              backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                              showCancelBtn: true,
                                                              cancelBtnText: 'Cancel',
                                                              cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                              onConfirmBtnTap: () async {
                                                                Response res = await SpeechFireCrud.deleteRecord(id: speechList[i].id!);
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

  viewPopup(SpeechModel speech) {
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
                          speech.firstName!,
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
                                image: NetworkImage(speech.imgUrl!),
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
                                        "${speech.firstName!} ${speech.lastName!}",
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
                                        speech.position!,
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
                                          text: "Speech",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: Text(
                                          speech.speech!,
                                          style: const TextStyle(
                                              fontSize: 14
                                          ),
                                        ),
                                      )
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

  editPopUp(SpeechModel speech, Size size) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: size.height * 1.05,
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
                          text: "EDIT SPEECH",
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
                              firstNameController.text = "";
                              lastNameController.text = "";
                              positionController.text = "";
                              speechController.text = "";
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
                              const SizedBox(width: 20),
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
                            ],
                          ),
                          const SizedBox(height: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Speech",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
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
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:
                                            const TextStyle(fontSize: 12),
                                            controller: speechController,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: 15,top: 4,bottom: 4)
                                            ),
                                            maxLines: null,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Facebook",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: facebookController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Twitter",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: twitterController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Google+",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: googleplusController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Linkedin",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: linkedinController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 30),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Youtube",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: youtubeController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Pinterest",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: pinterestController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Instagram",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: instagramController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Whatsapp",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: const TextStyle(fontSize: 12),
                          //             controller: whatsappController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (
                                      firstNameController.text != "" &&
                                      lastNameController.text != "" &&
                                      positionController.text != "" &&
                                      speechController.text != ""
                                     // facebookController.text != "" &&
                                     // twitterController.text != "" &&
                                     // googleplusController.text != "" &&
                                     // linkedinController.text != "" &&
                                     // pinterestController.text != "" &&
                                     // youtubeController.text != "" &&
                                     // instagramController.text != "" &&
                                     // whatsappController.text != ""
                                  ) {
                                    Response response =
                                    await SpeechFireCrud.updateRecord(
                                      SpeechModel(
                                        id: speech.id,
                                        timestamp: speech.timestamp,
                                        linkedin: linkedinController.text,
                                        pinterest: pinterestController.text,
                                        speech: speechController.text,
                                        twitter: twitterController.text,
                                        whatsapp: whatsappController.text,
                                        youtube: youtubeController.text,
                                        instagram: instagramController.text,
                                        google: googleplusController.text,
                                        facebook: facebookController.text,
                                        position: positionController.text,
                                        lastName: lastNameController.text,
                                        firstName: firstNameController.text,
                                      ),
                                        profileImage,
                                        speech.imgUrl ?? ""
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Speech updated successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        uploadedImage = null;
                                        profileImage = null;
                                        linkedinController.text == "";
                                        pinterestController.text == "";
                                        speechController.text == "";
                                        twitterController.text == "";
                                        whatsappController.text == "";
                                        youtubeController.text == "";
                                        instagramController.text == "";
                                        googleplusController.text == "";
                                        facebookController.text == "";
                                        positionController.text == "";
                                        lastNameController.text == "";
                                        firstNameController.text == "";
                                      });
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to update Speech!",
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