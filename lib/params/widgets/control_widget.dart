import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickctl/params/model.dart';
import 'package:quickctl/params/widgets/control_item_list.dart';
import 'package:quickctl/services/utils.dart';

class ControlWidget extends StatefulWidget {
  const ControlWidget({super.key});

  @override
  State<ControlWidget> createState() => _ControlWidgetState();
}

class _ControlWidgetState extends State<ControlWidget> {
  final values = ControlValues();

  late Future<List<ControlGroup>> groups;

  @override
  void initState() {
    groups = readFromAsset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return resolve<List<ControlGroup>>(
      future: groups,
      onData: (ctx, data) {
        if (data == null || data.isEmpty) {
          return const Center(child: Text("Nothing to show"));
        }

        if (data.length == 1) {
          return ControlItemList(
            items: data[0].items,
            values: values,
            handler: (item, value) async => Future.value(true),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListView.builder(
            // shrinkWrap: true,
            // physics: const ClampingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              return ExpansionTile(
                initiallyExpanded: index == 0,
                title: Text(
                  data[index].name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  data[index].desc,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                children: [
                  Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.only(left: 4),
                    child: ControlItemList(
                      items: data[index].items,
                      values: values,
                      handler: (item, value) async => Future.value(true),
                    ),
                  )
                ],
              );
            },
          ),
        );

        // return SingleChildScrollView(
        //   child: Row(
        //     children: [
        //       for (var item in data)
        //         ControlItemWidget(
        //             items: item.items,
        //             values: ControlValues(),
        //             handler: (item, value) {})
        //     ],
        //   ),
        // );
      },
    );
  }

  Future<List<ControlGroup>> readFromAsset() async {
    String content = '[]';
    if (Platform.isAndroid) {
      content = await rootBundle.loadString('assets/ctlr_sample.json');
    } else if (Platform.isLinux) {
      content = await File('assets/ctlr_sample.json').readAsString();
    }

    final list = jsonDecode(content) as List<dynamic>;

    final cgs = <ControlGroup>[];
    for (var cgJson in list) {
      cgs.add(ControlGroup.fromJson(cgJson as Map<String, dynamic>));
    }

    return cgs;
  }
}
