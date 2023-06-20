import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_loading.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact> contacts = [];
  bool isLoading = true;
  PermissionStatus? _permissionStatus;
  @override
  void initState() {
    _getPermissionStatus();
    super.initState();
  }

  Future<void> _getPermissionStatus() async {
    final status = await Permission.contacts.status;
    setState(() {
      _permissionStatus = status;
    });

    if (status.isGranted) {
      _fetchContacts();
    } else if (status.isDenied) {
      final requestStatus = await Permission.contacts.request();
      setState(() {
        _permissionStatus = requestStatus;
      });
      if (requestStatus.isGranted) {
        _fetchContacts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const HeaderText(text: 'My Contacts', color: darkColor),
        ),
        body: isLoading
            ? const DefaultLoading()
            : ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    onTap: () => Navigator.pop(
                        context, contacts[index].phones!.first.value ?? ''),
                    splashColor: primaryColor,
                    leading: CircleAvatar(
                      backgroundColor: secondaryColor,
                      child: HeaderText(
                          text: contacts[index].displayName!.substring(0, 2) ??
                              '',
                          color: whiteColor),
                    ),
                    trailing: IconButton(
                        onPressed: () => Navigator.pop(
                            context, contacts[index].phones!.first.value ?? ''),
                        icon: const Icon(CupertinoIcons.add_circled_solid,
                            size: 30)),
                    subtitle: SmallText(
                        text: contacts[index].displayName ?? '',
                        color: darkColor),
                    title: SmallText(
                        text: contacts[index].phones!.first.value ?? '',
                        color: darkColor),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: contacts.length));
  }

  void _fetchContacts() async {
    setState(() {
      isLoading = true;
    });
    contacts = await ContactsService.getContacts();
    setState(() {
      isLoading = false;
    });
  }
}
