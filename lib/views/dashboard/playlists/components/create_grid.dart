import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loud/constants.dart';
import 'package:loud/controllers/theme_controller.dart';

class CreateGrid extends StatelessWidget {
  const CreateGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              color: ThemeController.to.isDark.value ? darkcolor : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(
                      ThemeController.to.isDark.value ? 0.05 : 0.19,
                    ),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: const Offset(3, 3))
              ],
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.add,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
