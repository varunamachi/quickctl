import 'dart:io';

import 'package:multicast_dns/multicast_dns.dart';
import 'package:quickctl/relayctl/exceptions.dart';
import 'package:quickctl/relayctl/model.dart';

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

Future<List<ServiceEntry>> discoverControllers({getIps = true}) async {
  // final MDnsClient client = MDnsClient(rawDatagramSocketFactory: RawDatagramSocket.bind);

  var client = MDnsClient(rawDatagramSocketFactory: factory);
  await client.start();
  final entries = <ServiceEntry>[];

  try {
    final foundNames = <String>{};
    // var ptrQuery = ResourceRecordQuery.serverPointer("_relayctl._tcp.local");
    final ptrQuery = ResourceRecordQuery.serverPointer("_relayctl._tcp.local");
    await for (final ptr in client.lookup<PtrResourceRecord>(ptrQuery)) {
      final serviceQuery = ResourceRecordQuery.service(ptr.domainName);
      await for (final srv in client.lookup<SrvResourceRecord>(serviceQuery)) {
        final id = "${srv.target}:${srv.port}";
        if (foundNames.contains(id)) {
          continue;
        }
        foundNames.add(id);
        final ip4 = await getIPv4Address(client, srv.target);
        final ip6 = await getIPv6Address(client, srv.target);
        entries.add(ServiceEntry(
          host: srv.target,
          port: srv.port,
          currentIp4: ip4,
          currentIp6: ip6,
        ));
      }
    }
  } finally {
    client.stop();
  }

  return entries;
}

Future<String> getFirstIPv4Address(ServiceEntry entry) async {
  final MDnsClient client = MDnsClient();

  final query = ResourceRecordQuery.addressIPv4(entry.host);
  await for (final ip in client.lookup<IPAddressResourceRecord>(query)) {
    return "${ip.address}:${entry.port}";
  }
  throw RelayControllerException(
      "failed to get IPv4 address for ${entry.host}");
}

Future<List<InternetAddress>> getIPv4Address(
    MDnsClient client, String srvName) async {
  final query = ResourceRecordQuery.addressIPv4(srvName);
  final ips = <InternetAddress>[];
  await for (final ip in client.lookup<IPAddressResourceRecord>(query)) {
    ips.add(ip.address);
  }
  return ips;
}

Future<List<InternetAddress>> getIPv6Address(
    MDnsClient client, String srvName) async {
  final query = ResourceRecordQuery.addressIPv6(srvName);
  final ips = <InternetAddress>[];
  await for (final ip in client.lookup<IPAddressResourceRecord>(query)) {
    ips.add(ip.address);
  }
  return ips;
}

Future<RawDatagramSocket> factory(dynamic host, int port,
    {bool? reuseAddress, bool? reusePort, int ttl = 1}) {
  return RawDatagramSocket.bind(host, port,
      reuseAddress: true, reusePort: false, ttl: ttl);
}
