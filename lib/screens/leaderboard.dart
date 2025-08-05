import 'package:assignment_app/helper/idea_storage.dart';
import 'package:assignment_app/models/idea_model.dart';
import 'package:assignment_app/screens/idea_listing.dart';
import 'package:flutter/material.dart';

enum LeaderboardSortCriteria { votes, rating }

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final IdeaStorage _repository = IdeaStorage();
  List<IdeaModel> _topIdeas = [];
  bool _isLoading = true;
  LeaderboardSortCriteria _sortCriteria = LeaderboardSortCriteria.votes;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    if (mounted) setState(() => _isLoading = true);

    final allIdeas = await _repository.getIdeas();

    if (_sortCriteria == LeaderboardSortCriteria.votes) {
      allIdeas.sort((a, b) => b.voteCount.compareTo(a.voteCount));
    } else {
      allIdeas.sort((a, b) => b.rating.compareTo(a.rating));
    }

    if (mounted) {
      setState(() {
        _topIdeas = allIdeas.take(5).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🏆 LEADERBOARD"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt_rounded),
            tooltip: 'View All Ideas',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const IdeaListing()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SegmentedButton<LeaderboardSortCriteria>(
              segments: const [
                ButtonSegment(
                  value: LeaderboardSortCriteria.votes,
                  label: Text('By Votes'),
                  icon: Icon(Icons.thumb_up),
                ),
                ButtonSegment(
                  value: LeaderboardSortCriteria.rating,
                  label: Text('By AI Rating'),
                  icon: Icon(Icons.auto_awesome),
                ),
              ],
              selected: {_sortCriteria},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _sortCriteria = newSelection.first;
                  _loadLeaderboard();
                });
              },
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_topIdeas.isEmpty) {
      return const Center(
        child: Text(
          "No ideas have been submitted yet!",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: _topIdeas.length,
      itemBuilder: (context, index) {
        final idea = _topIdeas[index];
        return _buildLeaderboardCard(idea, index);
      },
    );
  }
  Widget _buildLeaderboardCard(IdeaModel idea, int rank) {
    final colors = _getRankColors(rank, context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: colors['gradient'],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors['shadow']!.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        leading: _getBadgeForRank(rank),
        title: Text(
          idea.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: colors['text'],
          ),
        ),
        subtitle: Text(
          idea.tagline,
          style: TextStyle(
            fontSize: 14,
            color: colors['text']!.withOpacity(0.8),
          ),
        ),
        trailing: Text(
          _sortCriteria == LeaderboardSortCriteria.votes
              ? '${idea.voteCount} Votes'
              : '${idea.rating} Score',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: colors['text'],
          ),
        ),
      ),
    );
  }
  Widget _getBadgeForRank(int rank) {
    const double badgeSize = 40.0;
    switch (rank) {
      case 0:
        return const Text('🥇', style: TextStyle(fontSize: badgeSize));
      case 1:
        return const Text('🥈', style: TextStyle(fontSize: badgeSize));
      case 2:
        return const Text('🥉', style: TextStyle(fontSize: badgeSize));
      default:
        return CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          child: Text(
            '#${rank + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
    }
  }

  Map<String, dynamic> _getRankColors(int rank, BuildContext context) {
    switch (rank) {
      case 0: // Gold
        return {
          'gradient': const LinearGradient(
              colors: [Color(0xFFFDE047), Color(0xFFFBBF24)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          'shadow': const Color(0xFFFBBF24),
          'text': Colors.black87,
        };
      case 1: // Silver
        return {
          'gradient': const LinearGradient(
              colors: [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          'shadow': const Color(0xFFD1D5DB),
          'text': Colors.black87,
        };
      case 2: // Bronze
        return {
          'gradient': const LinearGradient(
              colors: [Color(0xFFFDBA74), Color(0xFFF97316)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          'shadow': const Color(0xFFF97316),
          'text': Colors.white,
        };
      default: 
        return {
          'gradient': LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                Theme.of(context).colorScheme.surfaceContainerHighest
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          'shadow': Theme.of(context).shadowColor,
          'text': Theme.of(context).colorScheme.onSurfaceVariant,
        };
    }
  }
}
