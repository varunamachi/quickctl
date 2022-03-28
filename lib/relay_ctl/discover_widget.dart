import 'package:flutter/material.dart';
import 'package:quickctl/relay_ctl/mdns.dart';
import 'package:quickctl/relay_ctl/model.dart';

class DiscoverWidget extends StatefulWidget {
  static const id = "relayctl.discover";

  DiscoverWidget({Key? key}) : super(key: key);

  @override
  State<DiscoverWidget> createState() => _DiscoverWidgetState();
}

class _DiscoverWidgetState extends State<DiscoverWidget> {
  Future<List<ServiceEntry>>? discovered;

  @override
  void initState() {
    setState(() {
      discovered = discoverControllers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
        future: discovered,
        builder: (context, AsyncSnapshot<List<ServiceEntry>> snapshot) {
          if (!snapshot.hasData && !snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("-- ${snapshot.error.toString()}--"));
          }
          // return Text("${snapshot.data?.length}");
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Text("${snapshot.data?[index].host}");
              });
        },
      ),
    );
  }
}
