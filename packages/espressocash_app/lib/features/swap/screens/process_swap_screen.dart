import 'package:auto_route/auto_route.dart';
import 'package:dfunc/dfunc.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/utils.dart';
import '../../../core/tokens/token.dart';
import '../../../di.dart';
import '../../../l10n/l10n.dart';
import '../../transactions/services/create_transaction_link.dart';
import '../../transactions/widgets/transfer_error.dart';
import '../../transactions/widgets/transfer_progress.dart';
import '../../transactions/widgets/transfer_success.dart';
import '../data/swap_repository.dart';
import '../models/swap.dart';
import '../widgets/extensions.dart';

@RoutePage()
class ProcessSwapScreen extends StatefulWidget {
  const ProcessSwapScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<ProcessSwapScreen> createState() => _ProcessSwapScreenState();
}

class _ProcessSwapScreenState extends State<ProcessSwapScreen> {
  late final Stream<Swap?> _swap;

  @override
  void initState() {
    super.initState();
    _swap = sl<SwapRepository>().watch(widget.id);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<Swap?>(
        stream: _swap,
        builder: (context, snapshot) {
          final swap = snapshot.data;

          return swap == null
              ? TransferProgress(onBack: () => context.router.pop())
              : swap.status.maybeMap(
                  success: (status) => TransferSuccess(
                    onBack: () => context.router.pop(),
                    onOkPressed: () => context.router.pop(),
                    statusContent: swap.seed.inputToken == Token.usdc
                        ? context.l10n
                            .swapBuySuccess(swap.seed.outputToken.name)
                        : context.l10n
                            .swapSellSuccess(swap.seed.inputToken.name),
                    onMoreDetailsPressed: () {
                      final link = status.tx.id
                          .let(createTransactionLink)
                          .let(Uri.parse)
                          .toString();
                      context.openLink(link);
                    },
                  ),
                  txFailure: (it) => TransferError(
                    onBack: () => context.router.pop(),
                    onRetry: () => context.retrySwap(swap),
                    reason: it.reason,
                  ),
                  orElse: () => TransferProgress(
                    onBack: () => context.router.pop(),
                  ),
                );
        },
      );
}
