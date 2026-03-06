import 'package:ailiotte/features/notes/views/add_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/notes_controller.dart';

class NotesScreen extends StatelessWidget {
  NotesScreen({super.key});

  final controller = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          Obx(() {
            final controller = Get.find<NotesController>();

            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(
                controller.isSyncing.value
                    ? Icons.cloud_upload
                    : Icons.cloud_done,
                color: controller.isSyncing.value
                    ? Colors.orange
                    : Colors.green,
              ),
            );
          }),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Obx(() {
          if (controller.notes.isEmpty) {
            return Center(
              child: Text(
                "No notes yet",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: controller.notes.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final note = controller.notes[index];

              return Dismissible(
                key: Key(note.id),

                direction: DismissDirection.endToStart,

                onDismissed: (_) {
                  controller.deleteNote(note.id);
                },

                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(Icons.delete, color: Colors.white, size: 24.sp),
                ),

                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.text,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      IconButton(
                        icon: Icon(
                          note.liked ? Icons.favorite : Icons.favorite_border,
                          color: note.liked
                              ? Colors.red
                              : const Color(0xFF64748B),
                          size: 20.sp,
                        ),
                        onPressed: () {
                          controller.toggleLike(note);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F46E5),
        onPressed: () {
          Get.to(() => AddNoteScreen());
        },
        child: Icon(Icons.add, size: 24.sp, color: Colors.white),
      ),
    );
  }
}
