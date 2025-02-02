import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dropdown_state.dart';

class DropdownCubit extends Cubit<dynamic> {
  DropdownCubit(super.value);

  void onChanged(dynamic value) {
    emit(value);
  }
}
