import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class IconSelectorSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const IconSelectorSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    final icons = request.data as List<IconData>;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        children: icons.map((icon) {
          return IconButton(
            icon: Icon(icon, size: 28),
            onPressed: () => completer(SheetResponse(data: icon)),
          );
        }).toList(),
      ),
    );
  }
}
