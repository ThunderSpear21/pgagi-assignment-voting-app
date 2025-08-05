import 'dart:convert';
import 'package:assignment_app/models/idea_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdeaStorage {
  static const _ideasKey = 'ideas_list';
  static const _votedIdeasKey = 'voted_ideas';
  Future<void> addIdea(IdeaModel idea) async {
    final prefs = await SharedPreferences.getInstance();
    final List<IdeaModel> ideas = await getIdeas();
    ideas.add(idea);
    final List<String> ideasJson = ideas
        .map((i) => jsonEncode(i.toJson()))
        .toList();
    await prefs.setStringList(_ideasKey, ideasJson);
  }

  Future<List<IdeaModel>> getIdeas() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ideasJson = prefs.getStringList(_ideasKey);
    if (ideasJson == null) {
      return [];
    }
    final List<IdeaModel> ideas = ideasJson.map((jsonString) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return IdeaModel.fromJson(jsonMap);
    }).toList();

    return ideas;
  }

  Future<void> updateIdea(IdeaModel updatedIdea) async {
    final prefs = await SharedPreferences.getInstance();
    final List<IdeaModel> ideas = await getIdeas();
    final int index = ideas.indexWhere((idea) => idea.id == updatedIdea.id);
    if (index != -1) {
      ideas[index] = updatedIdea;
      final List<String> ideasJson = ideas
          .map((i) => jsonEncode(i.toJson()))
          .toList();
      await prefs.setStringList(_ideasKey, ideasJson);
    }
  }
  Future<List<String>> getVotedIdeaIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_votedIdeasKey) ?? [];
  }

  // --- NEW: Save the updated list of voted IDs ---
  Future<void> saveVotedIdeaIds(List<String> votedIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_votedIdeasKey, votedIds);
  }
}
