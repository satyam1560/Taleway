import 'package:flutter/material.dart';
import 'package:viewstories/enums/enums.dart';

class ReportTile extends StatelessWidget {
  final String label;

  final Function(ReportPost? value) onTap;

  final ReportPost reportPost;
  final ReportPost value;

  const ReportTile({
    Key? key,
    required this.value,
    required this.label,
    required this.onTap,
    required this.reportPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      leading: Radio<ReportPost>(
        value: value,
        groupValue: reportPost,
        onChanged: onTap,
      ),
    );
  }
}
