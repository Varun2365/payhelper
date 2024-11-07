// ignore_for_file: must_be_immutable, non_constant_identifier_names, unused_local_variable, unused_import, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:billing/Handlers/JSONHandler.dart';
import 'package:billing/ProductsPage/productspagelarge.dart';
import 'package:billing/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPageLarge extends StatefulWidget {
  const SettingsPageLarge({super.key});

  @override
  State<SettingsPageLarge> createState() => _SettingsPageLargeState();
}

class _SettingsPageLargeState extends State<SettingsPageLarge> {
  late double rootFontSize;
  late double shortWidth;
  late double longWidth;
  late double mainHeadingSize;
  late double subHeadingSize;

  //TextEditingControllers - For Account Settings
  TextEditingController invoicePrefixController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController firmGSTController = TextEditingController();
  TextEditingController firmContactController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController addressLine3Controller = TextEditingController();

  // Function to save Account Settings to firmDetails.json File
  void saveAccountSettings() {
    File firmDetails = File("Database/Firm/firmDetails.json");
    dynamic firmContent = firmDetails.readAsStringSync();
    firmContent = jsonDecode(firmContent);
    firmContent['FirmName'] = firmNameController.text;
    firmContent['InvoicePrefix'] = invoicePrefixController.text;
    firmContent['GSTNo'] = firmGSTController.text;
    firmContent['Address1'] = addressLine1Controller.text;
    firmContent['Address2'] = addressLine2Controller.text;
    firmContent['Address3'] = addressLine3Controller.text;
    firmContent['Contact'] = firmContactController.text;
    firmDetails.writeAsStringSync(jsonEncode(firmContent));
  }

  @override
  void initState() {
    rootFontSize = getRootFontSize();
    shortWidth = rootFontSize * 23;
    longWidth = rootFontSize * 35;
    mainHeadingSize = rootFontSize * 1.5;
    subHeadingSize = rootFontSize;
    File firmDetails = File("Database/Firm/firmDetails.json");
    dynamic firmContent = firmDetails.readAsStringSync();
    firmContent = jsonDecode(firmContent);
    firmNameController.text = firmContent['FirmName'];
    invoicePrefixController.text = firmContent['InvoicePrefix'];
    firmGSTController.text = firmContent['GSTNo'];
    addressLine1Controller.text = firmContent['Address1'];
    addressLine2Controller.text = firmContent['Address2'];
    addressLine3Controller.text = firmContent['Address3'];
    firmContactController.text = firmContent['Contact'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Text(
          "Settings & Preferences",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: ColorPalette.darkBlue,
        leading: InkWell(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: ColorPalette.offWhite.withOpacity(0.5),
        ),
        child: SizedBox(
          width: 800,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DisplaySettings(),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    // height: 1900,
                    width: 1300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "INVOICE ",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: mainHeadingSize,
                                      color: ColorPalette.dark)),
                              TextSpan(
                                  text: "SETTINGS",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: mainHeadingSize,
                                      color: Colors.black))
                            ])),
                            Tooltip(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: ColorPalette.dark.withOpacity(0.9)),
                              textStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                              message:
                                  "Change Account Settings here\n\n- This information will be shown up at the top\nof the generated invoice.\n\n- Try to keep the information as short for a single line\n\n- Put a '\\n' between each phone number if you want to \nenter more than one phone number\n\n- Firm Address Line 3 will be displayed in bold\n\n- The Invoice Prefix is optional but must contain '-' at the end",
                              child: const Icon(
                                Icons.info,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SettingsTextField(
                          controller: invoicePrefixController,
                          label: "Invoice Prefix",
                          width: shortWidth,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SettingsTextField(
                                controller: firmNameController,
                                label: "Firm Name",
                                width: longWidth),
                            const SizedBox(
                              width: 40,
                            ),
                            SettingsTextField(
                                controller: addressLine1Controller,
                                label: "Firm Address Line 1",
                                width: longWidth)
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SettingsTextField(
                                controller: firmGSTController,
                                label: "Firm GST No.",
                                width: longWidth),
                            const SizedBox(
                              width: 40,
                            ),
                            SettingsTextField(
                                controller: addressLine2Controller,
                                label: "Firm Address Line 2",
                                width: longWidth)
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SettingsTextField(
                                controller: firmContactController,
                                label: "Firm Contact",
                                width: longWidth),
                            const SizedBox(
                              width: 40,
                            ),
                            SettingsTextField(
                                controller: addressLine3Controller,
                                label: "Firm Address Line 3",
                                width: longWidth)
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                backgroundColor:
                                    WidgetStatePropertyAll(ColorPalette.dark)),
                            onPressed: () {
                              saveAccountSettings();
                              showAlert(context, "Account Settings Were Saved");
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 29.0, vertical: 9),
                              child: Text(
                                "Save Account Info",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const BankingAndTNCSection(),
                  const QRDetails(),
                  const BackupSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BankingAndTNCSection extends StatefulWidget {
  const BankingAndTNCSection({super.key});

  @override
  State<BankingAndTNCSection> createState() => _BankingAndTNCSectionState();
}

class _BankingAndTNCSectionState extends State<BankingAndTNCSection> {
  late double rootFontSize;
  late double shortWidth;
  late double longWidth;
  late double mainHeadingSize;
  late double subHeadingSize;

  //Setting Up Bank Details TextEditingControllers
  TextEditingController bankLine1Controller = TextEditingController();
  TextEditingController bankLine2Controller = TextEditingController();
  TextEditingController bankLine3Controller = TextEditingController();

  // Setting Up T&C Details TextEditingControllers
  TextEditingController tncLine1Controller = TextEditingController();
  TextEditingController tncLine2Controller = TextEditingController();
  TextEditingController tncLine3Controller = TextEditingController();
  TextEditingController tncLine4Controller = TextEditingController();
  File firmDetails = File("Database/Firm/firmDetails.json");

  @override
  void initState() {
    rootFontSize = getRootFontSize();
    shortWidth = rootFontSize * 23;
    longWidth = rootFontSize * 35;
    mainHeadingSize = rootFontSize * 1.5;
    subHeadingSize = rootFontSize;

    dynamic firmContent = firmDetails.readAsStringSync();
    firmContent = jsonDecode(firmContent);
    bankLine1Controller.text = firmContent['Bank1'];
    bankLine2Controller.text = firmContent['Bank2'];
    bankLine3Controller.text = firmContent['Bank3'];
    tncLine1Controller.text = firmContent['TNC1'];
    tncLine2Controller.text = firmContent['TNC2'];
    tncLine3Controller.text = firmContent['TNC3'];
    tncLine4Controller.text = firmContent['TNC4'];
    super.initState();
  }

  void saveBankingDetails() {
    dynamic firmContent = firmDetails.readAsStringSync();
    firmContent = jsonDecode(firmContent);
    firmContent['Bank1'] = bankLine1Controller.text;
    firmContent['Bank2'] = bankLine2Controller.text;
    firmContent['Bank3'] = bankLine3Controller.text;
    firmDetails.writeAsStringSync(jsonEncode(firmContent));
  }

  void saveTNCDetails() {
    dynamic firmContent = firmDetails.readAsStringSync();
    firmContent = jsonDecode(firmContent);
    firmContent['TNC1'] = tncLine1Controller.text;
    firmContent['TNC2'] = tncLine2Controller.text;
    firmContent['TNC3'] = tncLine3Controller.text;
    firmContent['TNC4'] = tncLine4Controller.text;
    firmDetails.writeAsStringSync(jsonEncode(firmContent));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        SizedBox(
          width: 1300,
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                width: 620,
                height: 600,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "BANKING ",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: mainHeadingSize,
                                      color: ColorPalette.dark)),
                              TextSpan(
                                  text: "DETAILS",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: mainHeadingSize,
                                      color: Colors.black))
                            ])),
                            Tooltip(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: ColorPalette.dark.withOpacity(0.9)),
                              textStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                              message:
                                  "Change Banking details here\n\n- This information will be shown at the banking section\nof the generated invoice.\n\n- Try to keep the information as short for a single line\n\n",
                              child: const Icon(
                                Icons.info,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SettingsTextField(
                            controller: bankLine1Controller,
                            label: "Banking Details Line 1",
                            width: double.infinity),
                        const SizedBox(
                          height: 20,
                        ),
                        SettingsTextField(
                            controller: bankLine2Controller,
                            label: "Banking Details Line 2",
                            width: double.infinity),
                        const SizedBox(
                          height: 20,
                        ),
                        SettingsTextField(
                            controller: bankLine3Controller,
                            label: "Banking Details Line 3",
                            width: double.infinity),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4))),
                            backgroundColor:
                                WidgetStatePropertyAll(ColorPalette.dark)),
                        onPressed: () {
                          saveBankingDetails();
                          showAlert(context, "Bank Details Were Saved");
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 29.0, vertical: 9),
                          child: Text(
                            "Save Bank Details",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(30),
                width: 620,
                height: 600,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "T&C ",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: mainHeadingSize,
                                      color: ColorPalette.dark)),
                              TextSpan(
                                  text: "DETAILS",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: mainHeadingSize,
                                      color: Colors.black))
                            ])),
                            Tooltip(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: ColorPalette.dark.withOpacity(0.9)),
                              textStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                              message:
                                  "Change Terms And Conditions here\n\n- This information will be shown at the bottom left section\nof the generated invoice.\n\n- Try to keep the information as short for a single line\n\n",
                              child: const Icon(
                                Icons.info,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SettingsTextField(
                            controller: tncLine1Controller,
                            label: "T&C Line 1",
                            width: double.infinity),
                        const SizedBox(
                          height: 20,
                        ),
                        SettingsTextField(
                            controller: tncLine2Controller,
                            label: "T&C Line 2",
                            width: double.infinity),
                        const SizedBox(
                          height: 20,
                        ),
                        SettingsTextField(
                            controller: tncLine3Controller,
                            label: "T&C Line 3",
                            width: double.infinity),
                        const SizedBox(
                          height: 20,
                        ),
                        SettingsTextField(
                            controller: tncLine4Controller,
                            label: "T&C Line 3",
                            width: double.infinity),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4))),
                            backgroundColor:
                                WidgetStatePropertyAll(ColorPalette.dark)),
                        onPressed: () {
                          saveTNCDetails();
                          showAlert(context, "Terms and Conditions Were Saved");
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 29.0, vertical: 9),
                          child: Text(
                            "Save T&C",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SettingsTextField extends StatefulWidget {
  TextEditingController controller;
  double width;
  String label;
  SettingsTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.width});

  @override
  State<SettingsTextField> createState() => _SettingsTextFieldState();
}

class _SettingsTextFieldState extends State<SettingsTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 3,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: ColorPalette.offWhite.withOpacity(0),
          ),
          height: 45,
          width: widget.width,
          child: Center(
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: ColorPalette.dark,
                    width: 0.6,
                  )),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 01.4, color: ColorPalette.dark)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
              controller: widget.controller,
            ),
          ),
        )
      ],
    );
  }
}

class DisplaySettings extends StatefulWidget {
  const DisplaySettings({super.key});

  @override
  State<DisplaySettings> createState() => _DisplaySettingsState();
}

class _DisplaySettingsState extends State<DisplaySettings> {
  File c = File("Database/avatar.jpg");
  late double rootFontSize;
  late String imagePath;
  late double shortWidth;
  late double longWidth;
  late double mainHeadingSize;
  late double subHeadingSize;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController fontSizeController = TextEditingController();
  Future<void> pickImageAndCopyToRoot() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      String selectedFilePath = result.files.single.path!;
      setState(() {
        imagePath = selectedFilePath;
      });
      try {
        File main = File(selectedFilePath);
        File avatar = File("data/flutter_assets/assets/images/avatar.jpg");

        List<int> bytes = await main.readAsBytes();
        await avatar.writeAsBytes(bytes);
        showAlert(context,
            "The profile picture was updated. Please restart the application to reflect changes.");
      } catch (e) {
        // Handle errors here, e.g., show a user-friendly error message
      }
    }
  }

  File firmDetails = File("Database/Firm/firmDetails.json");
  void saveDisplayName() {
    dynamic fd = firmDetails.readAsStringSync();
    fd = jsonDecode(fd);
    fd['DisplayName'] = displayNameController.text;
    fd['FontSize'] = fontSizeController.text;
    firmDetails.writeAsStringSync(jsonEncode(fd));
    showAlert(context,
        "Display Name and Image Were Saved Successfully, Restart the app to reflect changes");
  }

  void increaseFont() {
    int value = int.parse(fontSizeController.text);
    if (value <= 20) {
      ++value;
    }
    fontSizeController.text = value.toString();
  }

  void decreaseFont() {
    int value = int.parse(fontSizeController.text);
    if (value >= 14) {
      --value;
    }
    fontSizeController.text = value.toString();
  }

  @override
  void initState() {
    imagePath = "Database/avatar.jpg";
    rootFontSize = getRootFontSize();
    shortWidth = rootFontSize * 23;
    longWidth = rootFontSize * 35;
    mainHeadingSize = rootFontSize * 1.5;
    subHeadingSize = rootFontSize;
    dynamic content = firmDetails.readAsStringSync();
    content = jsonDecode(content);
    displayNameController.text = content['DisplayName'];
    fontSizeController.text = content['FontSize'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      width: 1300,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "PAYHELPER ",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: mainHeadingSize,
                        color: ColorPalette.dark)),
                TextSpan(
                    text: "SETTINGS",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: mainHeadingSize,
                        color: Colors.black))
              ])),
              Tooltip(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 9),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: ColorPalette.dark.withOpacity(0.9)),
                textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
                message:
                    "Change Terms And Conditions here\n\n- This information will be shown at the bottom left section\nof the generated invoice.\n\n- Try to keep the information as short for a single line\n\n",
                child: const Icon(
                  Icons.info,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SettingsTextField(
                controller: displayNameController,
                label: "Display Name",
                width: longWidth),
            Row(
              children: [
                CircleAvatar(
                  radius: 53,
                  backgroundColor: ColorPalette.dark,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                ),
                const SizedBox(
                  width: 55,
                )
              ],
            )
          ]),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,

                // height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Font Size",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: ColorPalette.dark, width: 0.6)),
                        child: TextField(
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.center,
                          controller: fontSizeController,
                          readOnly: true,
                          decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              prefixIcon: InkWell(
                                  onTap: decreaseFont,
                                  child: const Icon(Icons.remove)),
                              suffixIcon: InkWell(
                                  onTap: increaseFont,
                                  child: const Icon(Icons.add))),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                  style: ButtonStyle(
                      overlayColor:
                          const WidgetStatePropertyAll(Colors.transparent),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.transparent)),
                  onPressed: () {
                    pickImageAndCopyToRoot();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 29.0, vertical: 9),
                    child: Text(
                      textAlign: TextAlign.right,
                      "Upload Another Image",
                      style: TextStyle(
                        color: ColorPalette.dark,
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                  backgroundColor: WidgetStatePropertyAll(ColorPalette.dark)),
              onPressed: () {
                saveDisplayName();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 29.0, vertical: 9),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}

class QRDetails extends StatefulWidget {
  const QRDetails({super.key});

  @override
  State<QRDetails> createState() => _QRDetailsState();
}

class _QRDetailsState extends State<QRDetails> {
  late double rootFontSize;
  late double shortWidth;
  late double longWidth;
  late double mainHeadingSize;
  late double subHeadingSize;
  TextEditingController holderNameController = TextEditingController();
  TextEditingController upiController = TextEditingController();
  File firmDetails = File("Database/Firm/firmDetails.json");
  @override
  void initState() {
    rootFontSize = getRootFontSize();
    shortWidth = rootFontSize * 23;
    longWidth = rootFontSize * 35;
    mainHeadingSize = rootFontSize * 1.5;
    subHeadingSize = rootFontSize;
    dynamic content = firmDetails.readAsStringSync();
    content = jsonDecode(content);
    holderNameController.text = content['QRName'];
    upiController.text = content['QRUPI'];
    super.initState();
  }

  void saveQR() {
    dynamic fd = firmDetails.readAsStringSync();
    fd = jsonDecode(fd);
    fd['QRName'] = holderNameController.text;
    fd['QRUPI'] = upiController.text;
    firmDetails.writeAsStringSync(jsonEncode(fd));
    showAlert(context, "QR Details were saved successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Container(
          padding: const EdgeInsets.all(30),
          width: 1300,
          // height: 190,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "PAYMENT QR ",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: mainHeadingSize,
                            color: ColorPalette.dark)),
                    TextSpan(
                        text: "INFO",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: mainHeadingSize,
                            color: Colors.black))
                  ])),
                  Tooltip(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 9),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: ColorPalette.dark.withOpacity(0.9)),
                    textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                    message:
                        "Change Terms And Conditions here\n\n- This information will be shown at the bottom left section\nof the generated invoice.\n\n- Try to keep the information as short for a single line\n\n",
                    child: const Icon(
                      Icons.info,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SettingsTextField(
                      controller: holderNameController,
                      label: "Holder Name",
                      width: longWidth),
                  const SizedBox(
                    width: 40,
                  ),
                  SettingsTextField(
                      controller: upiController,
                      label: "UPI ID",
                      width: longWidth)
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                      backgroundColor:
                          WidgetStatePropertyAll(ColorPalette.dark)),
                  onPressed: () {
                    saveQR();
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 29.0, vertical: 9),
                    child: Text(
                      "Save QR Info",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class BackupSection extends StatefulWidget {
  const BackupSection({super.key});

  @override
  State<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<BackupSection> {
  late double rootFontSize;
  late double shortWidth;
  late double longWidth;
  late double mainHeadingSize;
  late double subHeadingSize;
  TextEditingController holderNameController = TextEditingController();
  TextEditingController upiController = TextEditingController();
  late String path;
  File firmDetails = File("Database/Firm/firmDetails.json");
  void selectFolder() async {
    dynamic pathh = await FilePicker.platform.getDirectoryPath();

    setState(() {
      path = pathh;
    });
  }

  void init() async {
    dynamic t = await getApplicationDocumentsDirectory();
    setState(() {
      path = t.path;
    });
  }

  @override
  void initState() {
    init();
    rootFontSize = getRootFontSize();
    shortWidth = rootFontSize * 23;
    longWidth = rootFontSize * 35;
    mainHeadingSize = rootFontSize * 1.5;
    subHeadingSize = rootFontSize;
    dynamic content = firmDetails.readAsStringSync();
    content = jsonDecode(content);
    holderNameController.text = content['QRName'];
    upiController.text = content['QRUPI'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Container(
          padding: const EdgeInsets.all(30),
          width: 1300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "DATA ",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: mainHeadingSize,
                            color: ColorPalette.dark)),
                    TextSpan(
                        text: "BACKUP",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: mainHeadingSize,
                            color: Colors.black))
                  ])),
                  Tooltip(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 9),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: ColorPalette.dark.withOpacity(0.9)),
                    textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                    message:
                        "Change Terms And Conditions here\n\n- This information will be shown at the bottom left section\nof the generated invoice.\n\n- Try to keep the information as short for a single line\n\n",
                    child: const Icon(
                      Icons.info,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Select a folder to save backup file",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
              ),
              const SizedBox(
                height: 4,
              ),
              InkWell(
                onTap: selectFolder,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorPalette.dark, width: 0.6),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ignore: unnecessary_string_escapes
                      Text(
                        "$path\PayHelperBackup.bkp",
                        style: const TextStyle(
                            fontFamily: 'Poppins', fontSize: 16),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Icon(
                          Icons.folder,
                          color: Color.fromARGB(255, 110, 110, 110),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                      backgroundColor:
                          WidgetStatePropertyAll(ColorPalette.dark)),
                  onPressed: () {},
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 29.0, vertical: 9),
                    child: Text(
                      "Save Backup",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
