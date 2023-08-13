import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


typedef AfterConfirm = Function(BuildContext);

class Confirmation {
  BuildContext context;
  String title;
  String message;
  String operation;
  AfterConfirm handler;

  Confirmation({
    required this.context,
    required this.handler,
    required this.title,
    required this.message,
    this.operation = '',
  });
}

void confirmExec(Confirmation cfm) {
  showDialog<bool>(
    context: cfm.context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(cfm.title),
        content: Text(cfm.message),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(cfm.context, false);
            },
          ),
          TextButton(
            child: Text(cfm.operation.isEmpty ? "Ok" : cfm.operation),
            onPressed: () {
              Navigator.pop(cfm.context, true);
            },
          ),
        ],
      );
    },
  ).then((bool? res) {
    if (res ?? false) {
      cfm.handler(cfm.context);
    }
  });
}

// String formatDateFromUTC(DateTime date, bool kn) {
//   if (date != null) {
//     date = date.add(Duration(hours: 5, minutes: 30));
//     return DateFormat("dd MMMM yyyy", kn ? "kn" : "en").format(date);
//   }
//   return "";
// }

DateTime parseDate(dynamic data) {
  return data != null ? DateTime.parse(data as String) : DateTime.now();
}

typedef DataHandler<T> = Widget Function(BuildContext ctx, T? data);
typedef ProgressHandler<T> = Widget Function();
typedef ErrorHandler = Widget Function(BuildContext ctx, Object err);

Widget resolve<T>({
  required Future<T>? future,
  required DataHandler<T> onData,
  ErrorHandler? onError,
  ProgressHandler? onProgress,
}) {
  return FutureBuilder<T>(
    future: future,
    builder: (context, snapshot) {
      if (!snapshot.hasData && !snapshot.hasError) {
        return onProgress != null
            ? onProgress()
            : const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasData) {
        return onData(context, snapshot.data);
      } else if (snapshot.hasError) {
        final error = snapshot.error;
        // if (error is ClientError) {
        //   if (error.statusCode == 401 || error.statusCode == 403) {
        //     if (MkClient().isAdminLogin()) {
        //       Timer.run(() async {
        //         showError(context, context.ln().adminRelogin);
        //         await context.read(authNotifierProvider.notifier).logout();
        //         popNav(context, PriceScreen.id);
        //       });
        //       return Text("");
        //     }
        //     Timer.run(() async {
        //       await MkClient().deviceLogin(await AppEnv.read());
        //       showError(context, context.ln().userRelogin);
        //       popNav(context, PriceScreen.id);
        //     });
        //     // return Text(context.ln().userRelogin);
        //   }
        // }
        return onError != null
            ? onError(context, snapshot.error ?? "An error occured")
            : Center(
                child: Text(snapshot.error.toString()),
              );
      }
      return const Text('-- -- --');
    },
  );
}

void showError(BuildContext ctx, String msg) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

void dumpAsJsonFile(String path, dynamic obj) {
  const encoder = JsonEncoder.withIndent('  ');
  final contents = encoder.convert(obj);
  final file = File(path);
  if (file.existsSync()) {
    file.deleteSync();
  }
  file.create(recursive: true);
  file.writeAsStringSync(contents, flush: true);
}

void writeBinaryFile(String path, Uint8List data) {
  final file = File(path);
  if (file.existsSync()) {
    file.deleteSync();
  }
  file.createSync(recursive: true);
  file.writeAsBytesSync(data, flush: true);
}

// ignore: avoid_classes_with_only_static_members
class MkPlatform {
  static bool get isMobile {
    if (kIsWeb) {
      return false;
    }
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool get isDesktop {
    if (kIsWeb) {
      return false;
    }
    return Platform.isLinux ||
        Platform.isMacOS ||
        Platform.isWindows ||
        Platform.isFuchsia;
  }

  static bool get isWeb => kIsWeb;

  static bool get isAndroid => (!kIsWeb) && Platform.isAndroid;

  static bool get isIOS => (!kIsWeb) && Platform.isIOS;

  static bool get isLinux => (!kIsWeb) && Platform.isLinux;

  static bool get isWindows => (!kIsWeb) && Platform.isWindows;

  static bool get isMacOS => (!kIsWeb) && Platform.isMacOS;

  static bool get isFachsia => (!kIsWeb) && Platform.isFuchsia;

  static String get desktopHomeDir {
    if (isWeb || MkPlatform.isMobile) {
      return '';
    }
    final envVars = Platform.environment;
    if (isWindows) {
      return envVars['UserProfile']!;
    }
    return envVars['HOME']!;
  }
}

String base64UrlEncode(String inStr) {
  // final bytes = utf8.encode(inStr);
  // return Base64Codec.urlSafe().encode(bytes);

  final stringToBase64Url = utf8.fuse(base64Url);
  final encoded = stringToBase64Url.encode(inStr);
  return encoded;
}

extension DateOnlyCompare on DateTime {
  bool isSameDayAs(DateTime? other) {
    if (other == null) {
      return false;
    }
    return year == other.year && month == other.month && day == other.day;
  }
}
