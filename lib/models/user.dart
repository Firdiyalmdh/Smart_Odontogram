import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String name;
  final String institute;

  const User({
    required this.email,
    required this.name,
    required this.institute,
  });

  @override
  List<Object?> get props => [email, name, institute];
}
