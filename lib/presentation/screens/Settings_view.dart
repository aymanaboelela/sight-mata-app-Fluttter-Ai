import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:sight_mate_app/core/utils/router/app_router.dart';
import 'package:sight_mate_app/presentation/widgets/SettingsListtile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryBlueColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body:   Column(
        children: [
          SizedBox(height: 20,),
          Settingslisttile(title: "About",icon: Icons.info_outline ,onTap: () {
             GoRouter.of(context)
                                  .pushReplacement(AppRouter.kAboutView);
          },),
          Settingslisttile(title: "Help",icon: Icons.help_outline ,onTap: () {
              GoRouter.of(context)
                                  .pushReplacement(AppRouter.khelpView);
          },),
          // Settingslisttile(title: "Dark Mode",icon: Icons.dark_mode_outlined ,),   doesn't exist in App
          Settingslisttile(title: "Privacy and Security",icon: Icons.security ,onTap:() {
            
          } ,),
          Settingslisttile(title: "language",icon: Icons.language ,onTap: () {
            
          },)

        ],
      ),
    );
  }
}