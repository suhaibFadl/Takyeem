import 'package:flutter_bloc/flutter_bloc.dart';

class MonthDropdownCubit extends Cubit<String> {
  MonthDropdownCubit(super.initialMonth);

  void onChanged(String value) {
    emit(value);
  }
}
