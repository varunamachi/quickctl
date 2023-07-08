import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickctl/relayctl/screens/controllers_screen.dart';
import 'package:quickctl/relayctl/screens/discover_screen.dart';
import 'package:quickctl/router.dart';

class _ScreenDesc {
  static const String routeIDNone = '';

  const _ScreenDesc({
    required this.name,
    required this.icon,
    required this.children,
    required this.route,
    // this.authRequired = false,
  });

  final String name;
  final String route;
  final IconData icon;
  final List<_ScreenDesc> children;
  final bool authRequired = false;
}

List<_ScreenDesc> getMenu(BuildContext ctx) {
  final menus = <_ScreenDesc>[
    const _ScreenDesc(
      name: "Controllers",
      icon: Icons.switch_access_shortcut,
      route: _ScreenDesc.routeIDNone,
      children: [
        _ScreenDesc(
          name: "Controllers",
          route: ControllersScreen.id,
          icon: Icons.present_to_all,
          children: [],
        ),
        _ScreenDesc(
          name: "Discover & Add",
          route: DiscoverScreen.id,
          icon: Icons.present_to_all,
          children: [],
        ),
      ],
    ),
  ];

  return menus;
}

class QScaffold extends StatelessWidget {
  final AppBar appBar;
  final Widget? floatingActionButton;
  final Widget body;

  const QScaffold({
    Key? key,
    required this.appBar,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: body,
      // bottomSheet: _getBottomSheet(context, notice),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    final menu = getMenu(context);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 120,
            child: DrawerHeader(
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsets.all(0),
              child: Center(
                child: Text(
                  "QuickCtl",
                  style: GoogleFonts.pacifico(
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: menu.length,
            itemBuilder: (BuildContext context, int index) {
              // return Text("$index - ${menu[index].name}");
              final header = menu[index];
              return Theme(
                data: theme,
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    header.name,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  leading: Icon(header.icon),
                  children: _buildSubMenu(context, header),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSubMenu(BuildContext context, _ScreenDesc desc) {
    var list = <Widget>[];
    for (var child in desc.children) {
      list.add(ListTile(
        leading: Icon(child.icon),
        title: Text(child.name),
        onTap: () {
          navigateTo(context, child.route);
        },
      ));
    }
    return list;
  }
}
