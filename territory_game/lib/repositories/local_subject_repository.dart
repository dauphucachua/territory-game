import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:territory_game/model/subject.dart';
import 'package:territory_game/repositories/subject_repository.dart';

class LocalSubjectRepository implements SubjectRepository {
  @override
  Future<List<Subject>> getSubjects() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    final jsonPaths = manifest
        .listAssets()
        .where((path) => path.startsWith("assets/json/"));
    
    final subjects = <Subject>[];

    for (String path in jsonPaths) {
      final jsonString = await rootBundle.loadString(path);
      final jsonData = await jsonDecode(jsonString) as Map<String, dynamic>;
      subjects.add(Subject.fromJson(jsonData));
    }

    return subjects;
    
    


  }
}