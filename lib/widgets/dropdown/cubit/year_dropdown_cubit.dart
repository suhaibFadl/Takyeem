import 'package:flutter_bloc/flutter_bloc.dart';

class YearDropdownCubit extends Cubit<int> {
  YearDropdownCubit(super.initialYear);

  void onChanged(int value) {
    emit(value);
  }
}
