import 'package:get/get.dart';
import 'package:odontogram/modules/patient/index.dart';
import 'package:odontogram/modules/home/index.dart';
import 'package:odontogram/modules/auth/index.dart';
import 'package:odontogram/modules/medical_exam/index.dart';
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
      binding: AddPatientBinding(),
      preventDuplicates: true,
    ),
    GetPage<DetailPatientScreen>(
      name: AppRoutes.DETAIL_PATIENT,
      page: () => const DetailPatientScreen(),
      binding: DetailPatientBinding(),
      preventDuplicates: true,
    ),
    GetPage<MedicalExamScreen>(
      name: AppRoutes.NEW_MEDICAL_EXAM,
      page: () => const MedicalExamScreen(),
      binding: MedicalExamBinding(),
      preventDuplicates: true,
    ),
    GetPage<NativeClassificationScreen>(
      name: AppRoutes.NATIVE_CLASSIFICATION,
      page: () => const NativeClassificationScreen(),
      binding: NativeClassificationBinding(),
      preventDuplicates: true,
    ),
  ];
}
