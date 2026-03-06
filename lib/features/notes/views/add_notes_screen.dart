import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/notes_controller.dart';

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({super.key});

  final controller = Get.find<NotesController>();

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Add Note",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Write something",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
            ),

            SizedBox(height: 12.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),

              child: TextField(
                controller: textController,
                maxLines: 5,

                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFF1E293B),
                ),

                decoration: InputDecoration(
                  hintText: "Enter your note...",
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 30.h),

            SizedBox(
              width: double.infinity,
              height: 50.h,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),

                onPressed: () {
                  if (textController.text.trim().isEmpty) {
                    Get.snackbar(
                      "Empty Note",
                      "Please write something before saving",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  controller.addNote(textController.text.trim());

                  Get.back();

                  Future.delayed(const Duration(milliseconds: 200), () {
                    Get.snackbar(
                      "Saved",
                      "Note saved locally",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  });
                },

                child: Text(
                  "Save Note",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
