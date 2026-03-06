import 'package:ailiotte/core/routes/app_routes.dart';
import 'package:ailiotte/features/notes/views/add_notes_screen.dart';
import 'package:ailiotte/features/notes/views/notes_screen.dart';
import 'package:ailiotte/features/notes/views/spalsh_screen.dart';

import 'package:get/get.dart';

class AppPages {
  static List<GetPage> routes = [
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppRoutes.notesScreen, page: () => NotesScreen()),
    GetPage(name: AppRoutes.addNotesScreen, page: () => AddNoteScreen()),
  ];
}
