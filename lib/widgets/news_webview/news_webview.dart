
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../app_title/app_title.dart';

class NewsWebview extends StatefulWidget {
  final String newsUrl;
  const NewsWebview({super.key, required this.newsUrl});

  @override
  State<NewsWebview> createState() => _NewsWebviewState();
}

class _NewsWebviewState extends State<NewsWebview> {

  WebViewController controller = WebViewController();

  @override
  void initState() {
    controller.loadRequest(Uri.parse(widget.newsUrl));
    controller.enableZoom(true);
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 70.h,
        iconTheme: theme.iconTheme,
        scrolledUnderElevation: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppTitle(
                    width: 0,
                    theme: theme,
                    textStyleFirst: theme.textTheme.headlineMedium!,
                    textStyleSecond: theme.textTheme.headlineMedium!
                        .copyWith(color: theme.colorScheme.primary),
                    textStyleThird: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                    cWidth: 40.w,
                    cHeight: 22.h,
                    offset: Offset(3.w, -10.h),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
