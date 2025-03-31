
import 'package:equatable/equatable.dart';          

class TagEntity extends Equatable {
  final int id;
final String title;

  const TagEntity({
  required this.id,
required this.title,
  });

  @override
  List<Object?> get props => [id,title];
}

