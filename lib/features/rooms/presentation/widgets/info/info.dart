import 'package:flutter/material.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions:[ IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ))],
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: context.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromRGBO(237, 237, 237, 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Label(
                        text: 'اجمالي الحجز',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,color: Color.fromRGBO(82, 82, 82, 1),),
                    Label(
                        text: '195 جنيه',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              AppGaps.gap16Horizontal,

              Container(
                height: 100,
                width: context.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromRGBO(237, 237, 237, 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Label(
                        text: 'اجمالى الطلبات',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,color: Color.fromRGBO(82, 82, 82, 1),),
                    Label(
                        text: '370 جنية',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ),
            ],
          ),
          AppGaps.gap16Vertical,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: context.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromRGBO(237, 237, 237, 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Label(
                        text: 'اجمالي الخدمه والضريبه',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,color: Color.fromRGBO(82, 82, 82, 1),),
                    Label(
                        text: '195 جنيه',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              AppGaps.gap16Horizontal,

              Container(
                height: 100,
                width: context.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromRGBO(241, 217, 138, 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Label(
                        text: 'اجمالى الكلي',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,color: Color.fromRGBO(82, 82, 82, 1),),
                    Label(
                        text: '370 جنية',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
