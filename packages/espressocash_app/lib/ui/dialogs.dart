import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'button.dart';
import 'colors.dart';
import 'theme.dart';

void showErrorDialog(BuildContext context, String title, Exception e) =>
    showDialog<void>(
      context: context,
      builder: (context) => Theme(
        data: ThemeData.light(),
        child: AlertDialog(
          title: Text(title),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.ok),
            ),
          ],
        ),
      ),
    );

Future<void> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  required void Function() onConfirm,
  String? confirmLabel,
}) =>
    showModalBottomSheet(
      context: context,
      elevation: 0,
      barrierColor: _barrierColor,
      backgroundColor: CpColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(44),
          topRight: Radius.circular(44),
        ),
      ),
      builder: (context) => CpTheme.dark(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(64, 40, 64, 64),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              CpButton(
                text: confirmLabel ?? context.l10n.yes,
                width: double.infinity,
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
              ),
              const SizedBox(height: 16),
              CpButton(
                text: context.l10n.no,
                width: double.infinity,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );

Future<void> showWarningDialog(
  BuildContext context, {
  required String title,
  required String message,
}) =>
    showDialog(
      context: context,
      barrierColor: _barrierColor,
      builder: (context) => CpTheme.dark(
        child: Dialog(
          elevation: 0,
          backgroundColor: CpColors.primaryColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(44),
              bottomLeft: Radius.circular(44),
              bottomRight: Radius.circular(44),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    height: 1.3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                CpButton(
                  text: context.l10n.ok,
                  width: 170,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );

final _barrierColor = Colors.black.withOpacity(0.75);
