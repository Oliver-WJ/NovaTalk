import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class GetBuildView<T extends GetxController> extends GetView<T> {

  const GetBuildView({super.key});

  @override
  Widget build(BuildContext context) =>
      GetBuilder<T>(builder: (v) => builder.call(context));

  Widget builder(BuildContext context);
}
