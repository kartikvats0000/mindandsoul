import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameScreen extends StatefulWidget {
  final String url;
   const GameScreen({super.key, required this.url});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  WebViewController webViewController = WebViewController();

  var loadingPercentage = 0;
  @override
  void initState() {
    // TODO: implement initState
    webViewController = WebViewController()

      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.grey.shade200)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (loadingPercentage < 100)
          ? Center(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: loadingPercentage / 100.0,
                ),
              ),
            ),
            Center(
              child: Text('$loadingPercentage %',style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),),
            )
          ],
        ),
      )
          :WebViewWidget(
          controller: webViewController
      ),
    );
  }
}
