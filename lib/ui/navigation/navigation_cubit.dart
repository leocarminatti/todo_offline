import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationState { todo, create, search, done }

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState.todo);

  void changeTab(int index) {
    switch (index) {
      case 0:
        emit(NavigationState.todo);
        break;
      case 1:
        emit(NavigationState.create);
        break;
      case 2:
        emit(NavigationState.search);
        break;
      case 3:
        emit(NavigationState.done);
        break;
      default:
        emit(NavigationState.todo);
    }
  }
}
