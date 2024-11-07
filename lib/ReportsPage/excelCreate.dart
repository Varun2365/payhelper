// Create a new Excel document.
// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:billing/components/addItemComponenets.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

void excelGenerate(String year, String startMonth, String endMonth) async {
  //Initialising Required Files and Values.
  List Months = [
    '',
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
  List monthList = [];
  int startMonthIndex = Months.indexOf(startMonth);
  int endMonthIndex = Months.indexOf(endMonth);
  for (var i = startMonthIndex; i <= endMonthIndex; i++) {
    var temp = i.toString();
    if (temp.length == 1) {
      temp = "0$temp";
    }
    monthList.add(temp);
  }

  monthList.sort();
  String startRowIndex = "7";
  File salesFile = File("Database/Invoices/In.json");
  dynamic salesFileContent = salesFile.readAsStringSync();
  salesFileContent = jsonDecode(salesFileContent);
  List availableMonths = salesFileContent[year].keys.toList();
  // Create a new Excel document.
  final Workbook workbook = Workbook();
//Accessing worksheet via index.
  workbook.worksheets[0];
  final Worksheet sheet = workbook.worksheets[0];
  sheet.name = "Sales Record";
  sheet.tabColor = "#00a10d";
  sheet.isTabColorApplied = true;
  //Style for Top Heading
  final Style mergeHeadingStyle = workbook.styles.add('mergeHeadingStyle');
  mergeHeadingStyle.hAlign = HAlignType.center;
  mergeHeadingStyle.vAlign = VAlignType.center;
  mergeHeadingStyle.borders.all.lineStyle = LineStyle.medium;
  mergeHeadingStyle.borders.all.color = "#000000";
  mergeHeadingStyle.wrapText = true;
  mergeHeadingStyle.fontSize = 20;
  mergeHeadingStyle.backColor = '#ebebeb';

  final Style contentRowStyle = workbook.styles.add('contentRowStyle');
  contentRowStyle.vAlign = VAlignType.top;
  contentRowStyle.indent = 1;
  final Style contenHeadStyle = workbook.styles.add('contenHeadStyle');
  contenHeadStyle.fontSize = 16;
  contenHeadStyle.vAlign = VAlignType.center;
  contenHeadStyle.hAlign = HAlignType.center;
  contenHeadStyle.bold = true;
  contenHeadStyle.indent = 1;
  contenHeadStyle.backColor = "#acfcb5";
  final Style footerStyle = workbook.styles.add('footerStyle');
  footerStyle.vAlign = VAlignType.center;
  footerStyle.hAlign = HAlignType.left;
  footerStyle.bold = true;
  footerStyle.indent = 1;
  footerStyle.backColor = "#ffdfc9";

  final Style rowHeadingStyle = workbook.styles.add('rowHeadingStyle');
  rowHeadingStyle.vAlign = VAlignType.center;
  rowHeadingStyle.hAlign = HAlignType.center;
  rowHeadingStyle.bold = true;
  rowHeadingStyle.borders.all.lineStyle = LineStyle.thin;
  rowHeadingStyle.borders.all.color = "#000000";
  rowHeadingStyle.fontName = 'Ebrima';

  sheet.getRangeByName('A1:J6').merge();
  sheet
      .getRangeByName("A1:J6")
      .setText("Sales Record 2024 ($startMonth-$endMonth)");
  sheet.getRangeByName("A1:J6").cellStyle = mergeHeadingStyle;
  //Set Column Width
  sheet.getRangeByName("A7").columnWidth = 10;
  sheet.getRangeByName("B7").columnWidth = 15;
  sheet.getRangeByName("C7").columnWidth = 30;
  sheet.getRangeByName("D7").columnWidth = 30;
  sheet.getRangeByName("E7").columnWidth = 30;
  sheet.getRangeByName("F7").columnWidth = 20;
  sheet.getRangeByName("G7").columnWidth = 15;
  sheet.getRangeByName("H7").columnWidth = 15;
  sheet.getRangeByName("I7").columnWidth = 15;
  sheet.getRangeByName("J7").columnWidth = 20;

  //Set Values

  for (var i = 0; i < monthList.length; i++) {
    if (availableMonths.contains(monthList[i])) {
      double totalCGST = 0,
          totalSGST = 0,
          totalIGST = 0,
          totalGrandTotal = 0,
          totalAmount = 0;
      dynamic tempFile = salesFileContent[year][monthList[i]];
      List<String> invoiceKeys = tempFile.keys.toList();
      //Setting Up Month heading.
      sheet.getRangeByName("A$startRowIndex:J$startRowIndex").merge();
      sheet
          .getRangeByName("A$startRowIndex:J$startRowIndex")
          .setText("${Months[int.parse(monthList[i])]} Sales");
      sheet.getRangeByName("A$startRowIndex:J$startRowIndex").cellStyle =
          contenHeadStyle;
      sheet.getRangeByName("A$startRowIndex:J$startRowIndex").rowHeight = 29;
      var tempIndex = int.parse(startRowIndex);
      tempIndex++;
      startRowIndex = tempIndex.toString();
      //Month Heading Setup end.
      //Setting Up Table Header
      sheet.getRangeByName("A$startRowIndex").setText("Inv No.");
      sheet.getRangeByName("B$startRowIndex").setText("Date");
      sheet.getRangeByName("C$startRowIndex").setText("Party Name & Address");
      sheet.getRangeByName("D$startRowIndex").setText("GST No.");
      sheet.getRangeByName("E$startRowIndex").setText("Products");
      sheet.getRangeByName("F$startRowIndex").setText("Amount");
      sheet.getRangeByName("G$startRowIndex").setText("CGST");
      sheet.getRangeByName("H$startRowIndex").setText("SGST");
      sheet.getRangeByName("I$startRowIndex").setText("IGST");
      sheet.getRangeByName("J$startRowIndex").setText("Grand Total");
      //Set Row Height
      sheet.getRangeByName("A$startRowIndex:J$startRowIndex").rowHeight = 23;
      //Set Row Height
      sheet.getRangeByName("A$startRowIndex:J$startRowIndex").cellStyle =
          rowHeadingStyle;
      var tempndex = int.parse(startRowIndex);
      tempndex++;
      startRowIndex = tempndex.toString();
      //Table Header Setup End
      for (var j = 0; j < invoiceKeys.length; j++) {
        dynamic tempContent = tempFile[invoiceKeys[j]];
        String tempProduct = "";
        dynamic products = tempContent['Products'];
        for (var k = 0; k < products.length; k++) {
          tempProduct += "${products[k]['name']}\n";
        }
        sheet.getRangeByName("A$startRowIndex:J$startRowIndex").cellStyle =
            contentRowStyle;
        sheet
            .getRangeByName("A$startRowIndex")
            .setText(invoiceKeys[j].toString());
        sheet.getRangeByName("B$startRowIndex").setText(tempContent['Date']);
        sheet.getRangeByName("C$startRowIndex").setText(
            "${tempContent['BillingName']}\n${tempContent['BillingAdd']}");
        sheet
            .getRangeByName("D$startRowIndex")
            .setText(tempContent['BillingGST']);
        sheet.getRangeByName("E$startRowIndex").setText(tempProduct);
        sheet
            .getRangeByName("F$startRowIndex")
            .setText(tempContent['TaxAmount']);
        totalAmount +=
            convertIndianFormattedStringToNumber(tempContent['TaxAmount']);
        sheet
            .getRangeByName("G$startRowIndex")
            .setText(tempContent['igst'] ? "" : tempContent['cgst']);
        totalCGST += tempContent['igst']
            ? 0
            : convertIndianFormattedStringToNumber(tempContent['cgst']);
        sheet
            .getRangeByName("H$startRowIndex")
            .setText(tempContent['igst'] ? "" : tempContent['sgst']);
        totalSGST += tempContent['igst']
            ? 0
            : convertIndianFormattedStringToNumber(tempContent['sgst']);

        sheet
            .getRangeByName("I$startRowIndex")
            .setText(tempContent['igst'] ? tempContent['igstV'] : "");
        totalSGST += tempContent['igst']
            ? convertIndianFormattedStringToNumber(tempContent['igstV'])
            : 0;

        sheet
            .getRangeByName("J$startRowIndex")
            .setText(tempContent['grandtotal']);
        totalGrandTotal +=
            convertIndianFormattedStringToNumber(tempContent['grandtotal']);

        var tempIndex = int.parse(startRowIndex);
        tempIndex++;
        startRowIndex = tempIndex.toString();
      }
      sheet.getRangeByName("A$startRowIndex:E$startRowIndex").merge();
      sheet.getRangeByName("A$startRowIndex:E$startRowIndex").setText("Total");
      sheet
          .getRangeByName("F$startRowIndex")
          .setText(formatIntegerToIndian(totalAmount));
      sheet
          .getRangeByName("G$startRowIndex")
          .setText(formatIntegerToIndian(totalCGST));
      sheet
          .getRangeByName("H$startRowIndex")
          .setText(formatIntegerToIndian(totalSGST));
      sheet
          .getRangeByName("I$startRowIndex")
          .setText(formatIntegerToIndian(totalIGST));
      sheet
          .getRangeByName("J$startRowIndex")
          .setText(formatIntegerToIndian(totalGrandTotal));
      sheet.getRangeByName("A$startRowIndex:J$startRowIndex").cellStyle =
          footerStyle;
      sheet.getRangeByName("A$startRowIndex:J$startRowIndex").rowHeight = 20;
      var tempIdex = int.parse(startRowIndex);
      tempIdex++;
      startRowIndex = tempIdex.toString();
      sheet.getRangeByName("A$startRowIndex:J$startRowIndex").merge();
      var tempdex = int.parse(startRowIndex);
      tempdex++;
      startRowIndex = tempdex.toString();
    } else {}
  }

// Save the document.
  final List<int> bytes = workbook.saveAsStream();
  String currentDirectory = await getPath();

  File('$currentDirectory\\$year-Sales Record-$startMonth-$endMonth.xlsx')
      .writeAsBytes(bytes);
  UrlLauncherPlatform.instance.launch(
    '$currentDirectory\\$year-Sales Record-$startMonth-$endMonth.xlsx',
    useSafariVC: false,
    useWebView: false,
    enableJavaScript: true,
    enableDomStorage: true,
    universalLinksOnly: false,
    headers: <String, String>{},
  );
//Dispose the workbook.
  workbook.dispose();
}

void generatePurchase(String year, String startMonth, String endMonth) async {
  //Initialising Required Files and Values.
  List Months = [
    '',
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
  List monthList = [];
  int startMonthIndex = Months.indexOf(startMonth);
  int endMonthIndex = Months.indexOf(endMonth);
  for (var i = startMonthIndex; i <= endMonthIndex; i++) {
    var temp = i.toString();
    if (temp.length == 1) {
      temp = "0$temp";
    }
    monthList.add(temp);
  }

  monthList.sort();
  String startRowIndex = "7";
  File PurchaseFile = File("Database/Invoices/purchase.json");
  dynamic PurchaseFileContent = PurchaseFile.readAsStringSync();
  PurchaseFileContent = jsonDecode(PurchaseFileContent);
  List availableMonths = PurchaseFileContent[year].keys.toList();

  // Create a new Excel document.
  final Workbook workbook = Workbook();
//Accessing worksheet via index.
  workbook.worksheets[0];
  final Worksheet sheet = workbook.worksheets[0];
  sheet.name = "Purchase Record";
  sheet.tabColor = "#00a10d";
  sheet.isTabColorApplied = true;
  //Style for Top Heading
  final Style mergeHeadingStyle = workbook.styles.add('mergeHeadingStyle');
  mergeHeadingStyle.hAlign = HAlignType.center;
  mergeHeadingStyle.vAlign = VAlignType.center;
  mergeHeadingStyle.borders.all.lineStyle = LineStyle.medium;
  mergeHeadingStyle.borders.all.color = "#000000";
  mergeHeadingStyle.wrapText = true;
  mergeHeadingStyle.fontSize = 20;
  mergeHeadingStyle.backColor = '#ebebeb';

  final Style contentRowStyle = workbook.styles.add('contentRowStyle');
  contentRowStyle.vAlign = VAlignType.top;
  contentRowStyle.indent = 1;
  final Style contenHeadStyle = workbook.styles.add('contenHeadStyle');
  contenHeadStyle.fontSize = 16;
  contenHeadStyle.vAlign = VAlignType.center;
  contenHeadStyle.hAlign = HAlignType.center;
  contenHeadStyle.bold = true;
  contenHeadStyle.indent = 1;
  contenHeadStyle.backColor = "#acfcb5";
  final Style footerStyle = workbook.styles.add('footerStyle');
  footerStyle.vAlign = VAlignType.center;
  footerStyle.hAlign = HAlignType.left;
  footerStyle.bold = true;
  footerStyle.indent = 1;
  footerStyle.backColor = "#ffdfc9";

  final Style rowHeadingStyle = workbook.styles.add('rowHeadingStyle');
  rowHeadingStyle.vAlign = VAlignType.center;
  rowHeadingStyle.hAlign = HAlignType.center;
  rowHeadingStyle.bold = true;
  rowHeadingStyle.borders.all.lineStyle = LineStyle.thin;
  rowHeadingStyle.borders.all.color = "#000000";
  rowHeadingStyle.fontName = 'Ebrima';

  sheet.getRangeByName('A1:H6').merge();
  sheet
      .getRangeByName("A1:H6")
      .setText("Purchase Record $year ($startMonth-$endMonth)");
  sheet.getRangeByName("A1:H6").cellStyle = mergeHeadingStyle;
  //Set Column Width
  sheet.getRangeByName("A7").columnWidth = 10;
  sheet.getRangeByName("B7").columnWidth = 15;
  sheet.getRangeByName("C7").columnWidth = 30;
  sheet.getRangeByName("D7").columnWidth = 30;
  sheet.getRangeByName("E7").columnWidth = 30;
  sheet.getRangeByName("F7").columnWidth = 20;
  sheet.getRangeByName("G7").columnWidth = 15;
  sheet.getRangeByName("H7").columnWidth = 20;

  //Set Values

  for (var i = 0; i < monthList.length; i++) {
    if (availableMonths.contains(monthList[i])) {
      double totalAmount = 0, totalTax = 0, grandTotal = 0;
      dynamic tempFile = PurchaseFileContent[year][monthList[i]];

      //Setting Up Month heading.
      sheet.getRangeByName("A$startRowIndex:H$startRowIndex").merge();
      sheet
          .getRangeByName("A$startRowIndex:H$startRowIndex")
          .setText("${Months[int.parse(monthList[i])]} Purchase");
      sheet.getRangeByName("A$startRowIndex:H$startRowIndex").cellStyle =
          contenHeadStyle;
      sheet.getRangeByName("A$startRowIndex:H$startRowIndex").rowHeight = 29;
      var tempIndex = int.parse(startRowIndex);
      tempIndex++;
      startRowIndex = tempIndex.toString();
      //Month Heading Setup end.
      //Setting Up Table Header
      sheet.getRangeByName("A$startRowIndex").setText("Inv No.");
      sheet.getRangeByName("B$startRowIndex").setText("Date");
      sheet.getRangeByName("C$startRowIndex").setText("Party Name & Address");
      sheet.getRangeByName("D$startRowIndex").setText("GST No.");
      sheet.getRangeByName("E$startRowIndex").setText("Products");
      sheet.getRangeByName("F$startRowIndex").setText("Total Amount");
      sheet.getRangeByName("G$startRowIndex").setText("Total Tax");
      sheet.getRangeByName("H$startRowIndex").setText("Grand Total");

      //Set Row Height
      sheet.getRangeByName("A$startRowIndex:H$startRowIndex").rowHeight = 23;
      //Set Row Height
      sheet.getRangeByName("A$startRowIndex:H$startRowIndex").cellStyle =
          rowHeadingStyle;
      var tempndex = int.parse(startRowIndex);
      tempndex++;
      startRowIndex = tempndex.toString();
      //Table Header Setup End

      for (var j = 0; j < tempFile.length; j++) {
        dynamic purchaseSpecial = tempFile[j];

        dynamic purchaseSpecialKeys = tempFile[j].keys.toList();

        dynamic tempContent = purchaseSpecial[purchaseSpecialKeys[0]];
        String tempProduct = "";
        dynamic products = tempContent['products'];
        for (var k = 0; k < products.length; k++) {
          tempProduct += "${products[k]['name']}\n";
        }
        sheet.getRangeByName("A$startRowIndex:H $startRowIndex").cellStyle =
            contentRowStyle;
        sheet.getRangeByName("A$startRowIndex").setText(j.toString());
        sheet.getRangeByName("B$startRowIndex").setText(tempContent['date']);
        sheet
            .getRangeByName("C$startRowIndex")
            .setText("${tempContent['name']}\n${tempContent['address']}");
        sheet.getRangeByName("D$startRowIndex").setText(tempContent['gst']);
        sheet.getRangeByName("E$startRowIndex").setText(tempProduct);
        sheet
            .getRangeByName("F$startRowIndex")
            .setText(tempContent['totalAmount']);
        totalAmount +=
            convertIndianFormattedStringToNumber(tempContent['totalAmount']);
        sheet
            .getRangeByName("G$startRowIndex")
            .setText(tempContent['totalTax']);
        totalTax +=
            convertIndianFormattedStringToNumber(tempContent['totalTax']);
        sheet
            .getRangeByName("H$startRowIndex")
            .setText(tempContent['grandTotal']);
        grandTotal +=
            convertIndianFormattedStringToNumber(tempContent['grandTotal']);

        var tempIndex = int.parse(startRowIndex);
        tempIndex++;
        startRowIndex = tempIndex.toString();
      }

      sheet.getRangeByName("A$startRowIndex:E$startRowIndex").merge();
      sheet.getRangeByName("A$startRowIndex:E$startRowIndex").setText("Total");
      sheet
          .getRangeByName("F$startRowIndex")
          .setText(formatIntegerToIndian(totalAmount));
      sheet
          .getRangeByName("G$startRowIndex")
          .setText(formatIntegerToIndian(totalTax));
      sheet
          .getRangeByName("H$startRowIndex")
          .setText(formatIntegerToIndian(grandTotal));

      sheet.getRangeByName("A$startRowIndex:H$startRowIndex").cellStyle =
          footerStyle;
      sheet.getRangeByName("A$startRowIndex:H$startRowIndex").rowHeight = 20;
      var tempIdex = int.parse(startRowIndex);
      tempIdex++;
      startRowIndex = tempIdex.toString();
      sheet.getRangeByName("A$startRowIndex:H$startRowIndex").merge();
      var tempdex = int.parse(startRowIndex);
      tempdex++;
      startRowIndex = tempdex.toString();
    } else {}
  }

// Save the document.
  final List<int> bytes = workbook.saveAsStream();
  String currentDirectory = await getPath();
  File('$currentDirectory\\Purchase-Record-$year-$startMonth-$endMonth.xlsx')
      .writeAsBytes(bytes);
  UrlLauncherPlatform.instance.launch(
    '$currentDirectory\\Purchase-Record-$year-$startMonth-$endMonth.xlsx',
    useSafariVC: false,
    useWebView: false,
    enableJavaScript: true,
    enableDomStorage: true,
    universalLinksOnly: false,
    headers: <String, String>{},
  );
//Dispose the workbook.
  workbook.dispose();
}

Future<String> getPath() async {
  String? path = await FilePicker.platform.getDirectoryPath();
  return path.toString();
}
