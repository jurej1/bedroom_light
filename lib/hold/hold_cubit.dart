import 'package:bloc/bloc.dart';

class HoldCubit extends Cubit<bool> {
  HoldCubit() : super(false);

  void pressDown() {
    emit(true);
  }

  void pressUp() {
    emit(false);
  }
}
