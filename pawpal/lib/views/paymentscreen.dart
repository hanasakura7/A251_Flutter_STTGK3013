//buat last sekali; kena tally dengan web hosting
import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final int credits;
  const PaymentScreen({super.key, required this.user, required this.credits});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController _webcontroller;
  late double screenHeight, screenWidth, resWidth;
  late String userName, userEmail, userPhone, userID;

  @override
  void initState() {
    userEmail = widget.user.userEmail.toString();
    userPhone = widget.user.userPhone.toString();
    userName = widget.user.userName.toString();

    userID = widget.user.userId.toString();
    super.initState();
    _webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/payment.php?email=$userEmail&phone=$userPhone&userid=$userID&name=$userName&credits=${widget.credits}',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color.fromARGB(255, 40, 164, 236),
      ),
      body: WebViewWidget(controller: _webcontroller),
    );
  }
}