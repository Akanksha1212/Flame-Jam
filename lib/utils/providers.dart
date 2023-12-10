import 'package:flamejam_coderjedi/utils/nakamaProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Providers {
  static final ref = ProviderContainer();

  static final nakamaProvider = ChangeNotifierProvider((_) => NakamaProvider());
}
