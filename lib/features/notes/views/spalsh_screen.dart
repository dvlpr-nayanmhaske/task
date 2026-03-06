import 'dart:async';
import 'package:ailiotte/core/routes/app_routes.dart';
import 'package:ailiotte/core/services/connectivity_service.dart';
import 'package:ailiotte/core/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() {
    /// Start connectivity listener
    ConnectivityService().startListening();

    /// Process any pending queue (runs in background)
    SyncService().processQueue();

    /// Navigate after splash delay
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.notesScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.note_alt_rounded,
                size: 50.sp,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              "Offline Notes",
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),

            SizedBox(height: 10.h),

            Text(
              "Write anywhere. Sync anytime.",
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
            ),

            SizedBox(height: 40.h),

            SizedBox(
              width: 24.w,
              height: 24.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF4F46E5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
