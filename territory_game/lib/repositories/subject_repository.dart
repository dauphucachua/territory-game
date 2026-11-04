import 'package:territory_game/model/subject.dart';

abstract interface class SubjectRepository {
  Future<List<Subject>> getSubjects();
}