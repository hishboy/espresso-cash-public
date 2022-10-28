import 'package:cryptoplease/features/legal/flow.dart';
import 'package:cryptoplease/l10n/l10n.dart';
import 'package:cryptoplease/ui/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsDisclaimer extends StatelessWidget {
  const TermsDisclaimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(
          text: context.l10n.byCreatingWalletYouAgree,
          children: [
            TextSpan(
              text: context.l10n.terms,
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.navigateToTermsOfUse(),
              style: const TextStyle(
                color: CpColors.yellowColor,
              ),
            ),
            TextSpan(text: context.l10n.and),
            TextSpan(
              text: context.l10n.privacyPolicy,
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.navigateToPrivacyPolicy(),
              style: const TextStyle(
                color: CpColors.yellowColor,
              ),
            ),
          ],
          style: Theme.of(context).textTheme.headline2?.copyWith(
                fontSize: 14,
                height: 1.1,
                fontWeight: FontWeight.w500,
              ),
        ),
      );
}