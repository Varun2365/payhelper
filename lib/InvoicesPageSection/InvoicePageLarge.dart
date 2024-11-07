// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_types_as_parameter_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:billing/InvoicesPageSection/InvoiesPageFiles/InvoiceDefaults.dart';
import 'package:billing/InvoicesPageSection/InvoiesPageFiles/MonthCheckBox.dart';
import 'package:billing/NavBar/LargeNavbar.dart';
import 'package:billing/colors.dart';
import 'package:billing/components/addItemComponenets.dart';
import 'package:billing/components/savePDF.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:qr_flutter/qr_flutter.dart';

List<String> Months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class InvoicePageLarge extends StatefulWidget {
  const InvoicePageLarge({super.key});

  @override
  State<InvoicePageLarge> createState() => _InvoicePageLargeState();
}

class _InvoicePageLargeState extends State<InvoicePageLarge> {
  List selectedMonths = [];
  // List selectedMonths = [
  //   InvoiceDefaults.Months[int.parse(InvoiceDefaults.defaultMonth) - 1]
  // ];

  void updateSelectedMonths(List l) {
    setState(() {
      selectedMonths = l;
    });
  }

  void changeFile() {
    setState(() {
      invoiceContent = Invoices.readAsStringSync();
      invoiceContent = jsonDecode(invoiceContent);
    });
  }

  late dynamic invoiceContent;
  String selectedYear = InvoiceDefaults.defaultYear;
  TextEditingController YearController =
      TextEditingController(text: InvoiceDefaults.defaultYear);
  TextEditingController MonthController = TextEditingController();
  File textSize = File("Database/Firm/firmDetails.json");
  List<DropdownMenuEntry<dynamic>> drop = [];
  List<DropdownMenuEntry<dynamic>> monthsMenu = [];
  File Invoices = File("Database/Invoices/In.json");
  void showMonths(String year) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: MonthCheckBox(
                year: year,
                HeadingSize: HeadingSize,
                selectedMonths: updateSelectedMonths,
                selected: selectedMonths,
              ));
        });
  }

  late int fontSize;
  late double HeadingSize, HeadingSize2, paraSize;
  void initializeSettings() {
    MonthController.text = Months[int.parse(InvoiceDefaults.defaultMonth) - 1];
    invoiceContent = Invoices.readAsStringSync();
    invoiceContent = jsonDecode(invoiceContent);
    List keys = invoiceContent.keys.toList();
    keys.sort();
    log(invoiceContent.keys.toList().toString());
    if (keys.contains(selectedYear)) {
      List months = invoiceContent[selectedYear].keys.toList();
      months.sort();
      for (var i = 0; i < months.length; i++) {
        monthsMenu.add(DropdownMenuEntry(
            value: months[i], label: Months[int.parse(months[i]) - 1]));
      }
      keys = keys.reversed.toList();
      for (var i = 0; i < keys.length; i++) {
        drop.add(DropdownMenuEntry(value: keys[i], label: keys[i]));
      }
    } else {
      log("Year for Invoice Details Not Present in the database.");
    }
    dynamic fileContent = textSize.readAsStringSync();
    fileContent = jsonDecode(fileContent);
    fontSize = int.parse(fileContent['FontSize']);
    HeadingSize = 1.7 * fontSize;
    HeadingSize2 = 0.9 * fontSize;
    paraSize = 0.8 * fontSize;
  }

  @override
  void initState() {
    initializeSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenWidth2 = MediaQuery.of(context).devicePixelRatio;
    double actualWidth = screenWidth / screenWidth2;
    double fontSize = 17;
    if (actualWidth < 1500) {
      fontSize = 13;
    } else if (actualWidth < 1700) {
      fontSize = 14;
    } else if (actualWidth < 1800) {
      fontSize = 16;
    }
    return Container(
      padding: const EdgeInsets.only(top: 38, right: 30, left: 30),
      color: ColorPalette.offWhite.withOpacity(0.5),
      child: Container(
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(95, 207, 207, 207),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 2))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13), topRight: Radius.circular(13))),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "All ",
                            style: TextStyle(
                                fontSize: fontSize*1.7,
                                fontWeight: FontWeight.bold,
                                color: ColorPalette.darkBlue)),
                        TextSpan(
                            text: "Invoices",
                            style: TextStyle(
                                fontSize: fontSize*1.7,
                                fontWeight: FontWeight.bold,
                                color: ColorPalette.blueAccent)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Financial Year",
                                style: TextStyle(
                                    fontSize: HeadingSize2,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              DropdownMenu(
                                  textStyle: TextStyle(fontSize: paraSize),
                                  trailingIcon:
                                      const Icon(Icons.keyboard_arrow_down),
                                  onSelected: (value) {
                                    setState(() {
                                      selectedMonths.clear();

                                      selectedYear = value.toString();
                                    });
                                  },
                                  inputDecorationTheme: InputDecorationTheme(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              width: 1.3, color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey))),
                                  controller: YearController,
                                  width: 160,
                                  dropdownMenuEntries: drop),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Row(
                            children: [
                              Text(
                                "Month",
                                style: TextStyle(
                                    fontSize: HeadingSize2,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 47,
                                width: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        width: 0.5,
                                        color: const Color.fromARGB(
                                            255, 21, 21, 21))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedMonths.length == 1
                                            ? selectedMonths[0]
                                            : selectedMonths.isEmpty
                                                ? "Select Month"
                                                : "Custom",
                                        style: TextStyle(fontSize: paraSize),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            showMonths(selectedYear);
                                          },
                                          child: const Icon(
                                              Icons.keyboard_arrow_down))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InvoiceRecordHeader(fontSize),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: selectedMonths.isEmpty
                  ? nullRecord()
                  : ListView.builder(
                      itemCount: selectedMonths.length,
                      itemBuilder: (c, i) {
                        return InvoiceBuider(
                            context: context,
                            fn: changeFile,
                            month: (Months.indexOf(selectedMonths[i]) + 1)
                                .toString(),
                            year: selectedYear,
                            content: invoiceContent,
                            fontSize: fontSize);
                      }),
            ))
          ],
        ),
      ),
    );
  }
}

Widget nullRecord() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: SvgPicture.asset("assets/images/norecord.svg"),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "No Data Found, Please Select a Valid Year and Month",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        )
      ],
    ),
  );
}

Widget nullRecord2() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: SvgPicture.asset("assets/images/noPurchase.svg"),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "No Data Found, Please Select a Valid Year and Month",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        )
      ],
    ),
  );
}

Widget nullRecord3() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: SvgPicture.asset("assets/images/noProducts.svg"),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "No Products Found",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        )
      ],
    ),
  );
}

Widget nullRecord4() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: SvgPicture.asset("assets/images/noParty.svg"),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "No Parties Found",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        )
      ],
    ),
  );
}

Widget InvoiceRecordHeader(double fontSize) {
  double containerWidth = 40;
  if(fontSize<=15){
    containerWidth = fontSize*2;
  }
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4), color: ColorPalette.blueAccent),
    padding: const EdgeInsets.only(left: 10, right: 10),
    height: 40,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InvoiceRecordHeaderText(containerWidth * 1.3, "S.No.", 0,fontSize),
        InvoiceRecordHeaderText(containerWidth * 7, "Party Name", 0,fontSize),
        InvoiceRecordHeaderText(containerWidth * 7, "Party Address", 0,fontSize),
        InvoiceRecordHeaderText(containerWidth * 5, "GST No.", 0,fontSize),
        InvoiceRecordHeaderText(containerWidth * 4, "Date", 0,fontSize),
        InvoiceRecordHeaderText(containerWidth * 6, "Description", 0,fontSize),
        InvoiceRecordHeaderText(containerWidth * 4, "Grand Total", 0,fontSize),
        InvoiceRecordHeaderText(containerWidth * 4, "Options", 0,fontSize),
      ],
    ),
  );
}

Widget InvoiceRecordHeader2(
    {required BuildContext context,
    required int index,
    required Function fn,
    required String month,
    required String year,
    required String sno,
    required String partyName,
    required String partyAddress,
    required String gst,
    required String date,
    required String desc,
    required String grandTotal,
    required double fontSize}) {
  int color = 1;
  double containerWidth = 40;
  if(fontSize<=15){
    containerWidth = fontSize*2;
  }

  return Column(
    children: [
      const SizedBox(
        height: 12,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: index % 2 == 0
              ? const Color.fromARGB(70, 215, 215, 215)
              : const Color.fromARGB(70, 255, 255, 255),
        ),
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 14, bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InvoiceRecordHeaderText2(containerWidth * 1.3, sno, color,fontSize),
            InvoiceRecordHeaderText2(containerWidth * 7, partyName, color,fontSize),
            InvoiceRecordHeaderText2(containerWidth * 7, partyAddress, color,fontSize),
            InvoiceRecordHeaderText2(containerWidth * 5, gst, color,fontSize),
            InvoiceRecordHeaderText2(containerWidth * 4, date, color,fontSize),
            InvoiceRecordHeaderText2(containerWidth * 6, desc, color,fontSize),
            InvoiceRecordHeaderText2(containerWidth * 4, grandTotal, color,fontSize),
            Container(
              width: containerWidth * 4,
              height: 50,
              color: Colors.transparent,
              child: Wrap(
                runSpacing: 15,
                // mainAxisAlignment: MainAxisAlignment.start,
                direction: Axis.horizontal,
                spacing: 13,
                alignment: WrapAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            showEditInvoiceWindow2(
                                context, sno, year, month, () {}, fn);
                          },
                          child: const Tooltip(
                              message: "Edit Invoice",
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ))),
                              const SizedBox(width: 15),
                      InkWell(
                          onTap: () async {
                            await PreviewSave(year, month, sno);
                            showDialog(
                                barrierColor: const Color.fromARGB(186, 0, 0, 0),
                                context: context,
                                builder: (BuildContext) {
                                  return Dialog(
                                    child: AspectRatio(
                                      aspectRatio: 21 / 29.7,
                                      child: PdfViewer.file(
                                          "Database/Invoices/tempInvoice.pdf"),
                                    ),
                                  );
                                });
                          },
                          child: const Tooltip(
                              message: "Preview Invoice",
                              child: Icon(
                                CupertinoIcons.eye,
                                color: Colors.pink,
                              ))),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            showQR(context,
                                convertIndianFormattedStringToNumber(grandTotal));
                          },
                          child: const Tooltip(
                              message: "Show Payment QR",
                              child: Icon(
                                Icons.qr_code_rounded,
                                color: Color.fromARGB(255, 48, 48, 48),
                              ))),
                              const SizedBox(width: 15),
                      InkWell(
                          onTap: () {
                            saveFile2(context, year, month, sno);
                          },
                          child: const Tooltip(
                              message: "Save to Device",
                              child: Icon(
                                Icons.save,
                                color: Colors.blue,
                              ))),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ],
  );
}

Widget InvoiceRecordHeaderText(
  double width,
  String text,
  int? color,
  double fontSize,
) {
  return SizedBox(
    width: width,
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize <= 15 ? fontSize : 15,
          color: color == 0 ? Colors.white : Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
    ),
  );
}

Widget PurchaseRecordHeaderText(
  double width,
  String text,
  int? color,
) {
  return SizedBox(
    width: width,
    child: Text(
      text,
      style: TextStyle(
          color: color == 0 ? Colors.white : Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
    ),
  );
}

Widget InvoiceRecordHeaderText3(
  double width,
  String text,
  int? color,
) {
  return SizedBox(
    width: width,
    child: Text(
      text,
      style: TextStyle(
          color:
              color == 0 ? Colors.white : const Color.fromARGB(255, 38, 38, 38),
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w400),
    ),
  );
}

Widget InvoiceRecordHeaderText4(
  double width,
  String text,
  String text2,
  int? color,
) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              color: color == 0
                  ? Colors.white
                  : const Color.fromARGB(255, 43, 43, 43),
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text2,
          style: TextStyle(
              color: color == 0
                  ? Colors.white
                  : const Color.fromARGB(255, 38, 38, 38),
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w400),
        ),
      ],
    ),
  );
}

Widget InvoiceRecordHeaderText2(double width, String text, int? color,double fontSize) {
  return SizedBox(
    width: width,
    child: Text(
      text,
      style: TextStyle(
          fontSize: fontSize<=15? 12:13,
          color:
              color == 0 ? Colors.white : const Color.fromARGB(255, 49, 49, 49),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400),
    ),
  );
}

Widget InvoiceBuider(
    {required BuildContext context,
    required String month,
    required Function fn,
    required String year,
    required dynamic content,
    required double fontSize}) {
  log(month);
  dynamic renderContent = {};
  List keys = [];
  if (month.length == 1) {
    month = "0$month";
  }
  List keyss = content[year].keys.toList();
  if (keyss.contains(month)) {
    renderContent = content[year][month];
    keys = renderContent.keys.toList();
    keys = keys.reversed.toList();
  } else {}
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 15,),
      Text(
        "${Months[int.parse(month) - 1]} Invoices",
        style: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Scrollbar(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: keys.length,
            itemBuilder: (c, i) {
              String desc = "";
              List products = renderContent[keys[i]]["Products"];
              for (var i = 0; i < products.length; i++) {
                desc = "${desc + products[i]["name"]}\n";
              }
              return InvoiceRecordHeader2(
                  month: month,
                  year: year,
                  fn: fn,
                  context: context,
                  index: i,
                  sno: keys[i].toString(),
                  partyName: renderContent[keys[i]]["BillingName"],
                  partyAddress: renderContent[keys[i]]["BillingAdd"],
                  gst: renderContent[keys[i]]["BillingGST"],
                  date: renderContent[keys[i]]["Date"],
                  desc: desc,
                  grandTotal: renderContent[keys[i]]["grandtotal"],
                  fontSize: fontSize
                  );
            }),
      ),
    ],
  );
}

void showQR(BuildContext context, double amount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 480,
          width: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 29,
                      ))
                ],
              ),
              Expanded(
                child: Center(
                  child: QrImageView(
                    gapless: false,
                    eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square, color: Color(0xff3049AA)),
                    dataModuleStyle: const QrDataModuleStyle(
                        color: Color(0xff3049AA),
                        dataModuleShape: QrDataModuleShape.square),
                    data:
                        "upi://pay?pa=8178770706@fam&pn=vaibhav kumar&am=$amount",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Name: Varun Kumar",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins'),
              ),
              const Text(
                "UPI ID: 9643606839@fam",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins'),
              ),
              Text(
                "Amount: $amount",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins'),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      );
    },
  );
}
