import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quickctl/relay_ctl/model.dart';

class DiscoveredControllers extends StatelessWidget {
  final Future<List<ServiceEntry>> serviceEntries;

  const DiscoveredControllers({
    Key? key,
    required this.serviceEntries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
        future: serviceEntries,
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
                final entry = snapshot.data?[index];
                if (entry == null) {
                  return const Text("N/A");
                }
                return ListTile(
                  // leading:
                  title: Text(entry.host.toUpperCase()),
                  subtitle: Text(
                    "${entry.currentIp4[0].address}:${entry.port}",
                    style: TextStyle(
                        fontFamily: GoogleFonts.shareTechMono().fontFamily),
                  ),
                  trailing: TextButton(
                    child: const Text("Add"),
                    onPressed: () {},
                    // icon: const Icon(Icons.add),
                  ),
                );
              });
        },
      ),
    );
  }
}
