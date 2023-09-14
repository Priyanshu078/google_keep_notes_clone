import 'package:equatable/equatable.dart';

class AddNotesState extends Equatable {
  final bool pinned;

  const AddNotesState({required this.pinned});
  @override
  List<Object?> get props => [pinned];
}
