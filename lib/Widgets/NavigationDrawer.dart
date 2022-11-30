import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scrumboard/Services/localStorageConnector.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Navigation'),
        ),
        Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                    ),
                    title: const Text('Retrieve from local'),
                    onTap: () async {
                      AlertDialog dialog =
                          await LocalStorageConnector().GetToken();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return dialog;
                          });
                    },
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
