import 'package:amaalmubarak/APIServices/DioClient.dart';
import 'package:amaalmubarak/Config/constants.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../Models/SubjectModels.dart';


class HomeController extends GetxController {
  var subject = <SubjectModel>[].obs;
  var courses = <Courses>[].obs;
  var updatedCourse = <Courses>[].obs;

  // Observable list of subjects

  var isLoading = true.obs; // Loading state

  final DioClient _dio = DioClient(); // Replace with your base URL

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();

    //CreatCourses();
  }

  // Fetch subjects from API
  Future<void> fetchSubjects() async {
    try {
      isLoading(true);
      final response = await _dio.dio.get(
          baseAPIURLV1 + subjectsAPI); // Replace with your endpoint

      if (response.statusCode == 200) {
        // Parse the response into a list of Subject objects
        subject.value = (response.data as List)
            .map((json) => SubjectModel.fromJson(json))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to fetch subjects",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addSubject(Courses newSubject) async {
    try {
      isLoading(true);
      // إرسال طلب POST إلى API
      final response = await _dio.dio.post(
        baseAPIURLV1 + teachersAPIPost, // التأكد من صحة عنوان الـ API
        data: newSubject.toJson(), // تحويل الكائن إلى JSON باستخدام toJson
      );

      if (response.statusCode == 200) {
        courses.add(newSubject); // إضافة الكائن الجديد إلى القائمة
        Get.snackbar("Success", "Subject added successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "Failed to add subject",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }}


