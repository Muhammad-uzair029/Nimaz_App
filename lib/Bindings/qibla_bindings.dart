import 'package:Nimaz_App_Demo/Controllers/qibla_controller.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';

class QiblaBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QiblaController>(() => QiblaController());
  }
}
