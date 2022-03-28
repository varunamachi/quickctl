import 'dart:io';

import 'package:multicast_dns/multicast_dns.dart';
import 'package:quickctl/relay_ctl/model.dart';

// class ServiceResolver {
//   static final ServiceResolver _instance = ServiceResolver._internal();

//   factory ServiceResolver() {
//     return _instance;
//   }

//   ServiceResolver._internal();

//   List<ServiceEntry> discover() {
//     final MDnsClient _client = MDnsClient();
//     return [];
//   }
// }

Future<List<ServiceEntry>> discoverControllers() async {
  // final MDnsClient client = MDnsClient(rawDatagramSocketFactory: RawDatagramSocket.bind);

  var client = MDnsClient(rawDatagramSocketFactory: factory);
  await client.start();
  final entries = <ServiceEntry>[];

  try {
    final foundNames = <String>{};
    // var ptrQuery = ResourceRecordQuery.serverPointer("_relayctl._tcp.local");
    var ptrQuery = ResourceRecordQuery.serverPointer("_relayctl._tcp.local");
    await for (final ptr in client.lookup<PtrResourceRecord>(ptrQuery)) {
      var serviceQuery = ResourceRecordQuery.service(ptr.domainName);
      await for (final srv in client.lookup<SrvResourceRecord>(serviceQuery)) {
        final id = "${srv.target}:${srv.port}";
        if (foundNames.contains(id)) {
          continue;
        }
        foundNames.add(id);
        entries.add(ServiceEntry(host: srv.target, port: srv.port));
      }
    }
  } finally {
    client.stop();
  }

  return entries;
}

Future<String> getAddress(ServiceEntry entry) async {
  final MDnsClient client = MDnsClient();

  final query = ResourceRecordQuery.addressIPv4(entry.host);
  await for (final ip in client.lookup<IPAddressResourceRecord>(query)) {
    return "${ip.address}:${entry.port}";
  }

  return "";
}

Future<RawDatagramSocket> factory(dynamic host, int port,
    {bool? reuseAddress, bool? reusePort, int ttl = 1}) {
  return RawDatagramSocket.bind(host, port,
      reuseAddress: true, reusePort: false, ttl: ttl);
}
