import "dart:convert";
import "package:billing/Handlers/JSONHandler.dart";
import "package:billing/Pairs/largeScreenPair.dart";
import "package:billing/colors.dart";
import "package:flutter/material.dart";

void main() {
  runApp(const AppEntry());
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  Map firmDetails = {
    "InvoicePrefix": " ",
    "DisplayName": "User 1",
    "FirmName": "Firm Name",
    "GSTNo": "Firm GST",
    "Address1": "-",
    "Address2": "-",
    "Address3": "-",
    "Contact": "",
    "Bank1": "-",
    "Bank2": "-",
    "Bank3": "-",
    "TNC1": "-",
    "TNC2": "-",
    "TNC3": "-",
    "TNC4": "-",
    "QRName": "XYZ",
    "QRUPI": "...",
    "FontSize": "17"
  };
  double fontSize = 19;
  void start() async {
    await createDirectory("Database");
    await createDirectory("Database/Party Records");
    await createDirectory("Database/PDF");
    await createDirectory("Database/Invoices");
    await createDirectory("Database/Firm");
    await createDirectory("Database/Products");
    createFile(name: "tempInvoice.json", folder: "Invoices");
    createFile(name: "Invoices.json", folder: "Invoices", content: "{}");
    createFile(
        name: "firmDetails.json",
        folder: "Firm",
        content: jsonEncode(firmDetails));
    createFile(name: "purchase.json", folder: "Invoices", content: "{}");
    createFile(name: "invoiceNumber.txt", folder: "Invoices", content: "1");
    createFile(name: "products.json", folder: "Products", content: "{}");
    createFile(
        name: "tempPurchase.json",
        folder: "Invoices",
        content: '{"items": []}');
    createFile(name: "In.json", folder: "Invoices", content: "{}");
    createFile(name: "Invoices.json", folder: "Invoices", content: "{}");
    createFile(name: "tempPdf.json", folder: "Invoices");
    createFile(name: "parties.json", folder: "Party Records", content: "{}");
    createFile(
        name: "purchaseParties.json", folder: "Party Records", content: "{}");
    createFile(
        name: "purchaseP arties.json", folder: "Party Records", content: "{}");
    createFile(name: "purchase.json", folder: "Party Records", content: "{}");
    createFile(name: "uniqueid.txt", folder: "Invoices", content: "1");
    createFile(name: "products.json", folder: "Products");
  }

  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            scrollbarTheme: const ScrollbarThemeData(
                trackBorderColor:
                    WidgetStatePropertyAll(Color.fromARGB(255, 233, 233, 233)),
                thickness: WidgetStatePropertyAll(6),
                thumbColor:
                    WidgetStatePropertyAll(Color.fromARGB(255, 195, 195, 195)),
                trackVisibility: WidgetStatePropertyAll(true),
                radius: Radius.circular(4),
                thumbVisibility: WidgetStatePropertyAll(true)),
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: ColorPalette.blueAccent.withOpacity(0.2)),
            datePickerTheme: const DatePickerThemeData(
                backgroundColor: Color.fromARGB(255, 255, 255, 255)),
            fontFamily: "Gilroy"),
        debugShowCheckedModeBanner: false,
        home: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1400) {
              return LargeScreenPair(
                fontSize: fontSize,
              );
            } else if (constraints.maxWidth <= 1279) {
              return Container(color: ColorPalette.offWhite);
            } else {
              return LargeScreenPair(fontSize: fontSize);
            }
          },
        ));
  }
}
