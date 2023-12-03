import 'package:get/get.dart';
import 'package:odontogram/pages/add_patient_screen.dart';
import 'package:odontogram/pages/classification_screen.dart';
import 'package:odontogram/pages/detail_patient_screen.dart';
import 'package:odontogram/modules/home/index.dart';
import 'package:odontogram/modules/auth/index.dart';
import 'package:odontogram/pages/new_medical_exam_screen.dart';
import 'package:odontogram/modules/splash/index.dart';
import 'package:odontogram/routes/app_routes.dart';

class AppPages {
  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<SplashScreen>(
      name: AppRoutes.START,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      preventDuplicates: true,
    ),
    GetPage<LoginScreen>(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      preventDuplicates: true,
    ),
    GetPage<RegisterScreen>(
      name: AppRoutes.REGISTER,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
      preventDuplicates: true,
    ),
    GetPage<HomeScreen>(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      preventDuplicates: true,
    ),
    GetPage<AddPatientScreen>(
      name: AppRoutes.ADD_PATIENT,
      page: () => const AddPatientScreen(),
      preventDuplicates: true,
    ),
    GetPage<DetailPatientScreen>(
      name: AppRoutes.DETAIL_PATIENT,
      page: () => const DetailPatientScreen(),
      preventDuplicates: true,
    ),
    GetPage<SplashScreen>(
      name: AppRoutes.NEW_MEDICAL_EXAM,
      page: () => const NewMedicalExamScreen(),
      preventDuplicates: true,
    ),
    GetPage<SplashScreen>(
      name: AppRoutes.CLASSIFICATION,
      page: () => const ClassificationScreen(),
      preventDuplicates: true,
    ),
  ];
}
