import 'dart:async';

import 'package:async/async.dart';
import 'package:dfunc/dfunc.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

import '../../../core/cancelable_job.dart';
import '../data/iskp_repository.dart';
import '../models/incoming_split_key_payment.dart';

abstract class PaymentWatcher {
  PaymentWatcher(this._repository);

  final ISKPRepository _repository;

  StreamSubscription<void>? _repoSubscription;
  final Map<String, CancelableOperation<void>> _operations = {};

  @protected
  Stream<IList<IncomingSplitKeyPayment>> watchPayments(
    ISKPRepository repository,
  );

  @protected
  CancelableJob<IncomingSplitKeyPayment> createJob(
    IncomingSplitKeyPayment payment,
  );

  void call({required VoidCallback onBalanceAffected}) {
    _repoSubscription =
        watchPayments(_repository).distinct().listen((payments) async {
      final keys = payments.map((e) => e.id).toSet();
      for (final key in _operations.keys.toSet()) {
        if (!keys.contains(key)) {
          await _operations[key]?.cancel();
        }
      }

      for (final payment in payments) {
        final job = _operations[payment.id];
        if (job != null) return;

        _operations[payment.id] =
            createJob(payment).call().then((newPayment) async {
          if (payment != newPayment) {
            if (newPayment.status.affectsBalance) {
              onBalanceAffected();
            }
            await _repository.save(newPayment);
          }
          _operations.remove(payment.id);
        });
      }
    });
  }

  @mustCallSuper
  void dispose() {
    _repoSubscription?.cancel();
    for (final subscription in _operations.values) {
      subscription.cancel();
    }
  }
}

extension on ISKPStatus {
  bool get affectsBalance => this.map(
        txCreated: F,
        txSent: F,
        txFailure: F,
        success: T,
      );
}
