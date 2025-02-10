import 'package:flutter/material.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/constants/constans.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';
import 'package:sight_mate_app/presentation/screens/Distance_Off_view.dart';

import 'package:sight_mate_app/presentation/screens/StartJourney_view.dart';
import 'package:sight_mate_app/presentation/screens/Users_views.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final PageController controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // تأجيل الوصول إلى controller.page حتى بعد بناء PageView
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentPage =
            controller.page!.toInt(); // حفظ الصفحة الحالية بعد بناء PageView
      });
    });
  }

  String name = CacheData.getData(key: userNameUser) ?? 'User';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlueColor,
        title: Row(
          children: [
            _currentPage == 0
                ? Container()
                : IconButton(
                    onPressed: () {
                      controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xff94B2C8),
              child: Icon(
                Icons.person_outlined,
                color: Color(0xff7897AD),
                size: 25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Bahnschrift',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page; // تحديث الصفحة الحالية عند التغيير
          });
        },
        children: [
          StartJourney(
            onTap: () {
              controller.animateToPage(1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
          ),
          DistanceOffView(
            onTap: () {
              controller.animateToPage(2,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
          ),
          UsersViews(
            onTap: () {
              controller.animateToPage(4,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
          )
        ],
      ),
    );
  }
}
