import 'package:assignment_app/helper/idea_storage.dart';
import 'package:assignment_app/models/idea_model.dart';
import 'package:flutter/material.dart';

enum SortBy { date, rating, votes }

class IdeaListing extends StatefulWidget {
  const IdeaListing({super.key});

  @override
  State<IdeaListing> createState() => _IdeaListingState();
}

class _IdeaListingState extends State<IdeaListing> {
  final IdeaStorage _repository = IdeaStorage();
  List<IdeaModel> _ideas = [];
  List<String> _votedIdeaIds = [];
  bool _isLoading = true;
  SortBy _currentSortBy = SortBy.date;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) setState(() => _isLoading = true);
    final ideas = await _repository.getIdeas();
    final votedIds = await _repository.getVotedIdeaIds();
    switch (_currentSortBy) {
      case SortBy.rating:
        ideas.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortBy.votes:
        ideas.sort((a, b) => b.voteCount.compareTo(a.voteCount));
        break;
      case SortBy.date:
        ideas.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
        break;
    }
    if (mounted) {
      setState(() {
        _ideas = ideas;
        _votedIdeaIds = votedIds;
        _isLoading = false;
      });
    }
  }

  Future<void> _upvoteIdea(IdeaModel idea) async {
    if (_votedIdeaIds.contains(idea.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You've already upvoted this idea!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    final updatedIdea = idea.copyWith(voteCount: idea.voteCount + 1);
    final updatedVotedIds = List<String>.from(_votedIdeaIds)..add(idea.id);
    await _repository.updateIdea(updatedIdea);
    await _repository.saveVotedIdeaIds(updatedVotedIds);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Upvote counted!"),
          backgroundColor: Colors.green,
        ),
      );
    }
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("STARTUP IDEAS"),
        centerTitle: true,
        actions: [
          PopupMenuButton<SortBy>(
            onSelected: (sortBy) {
              setState(() {
                _currentSortBy = sortBy;
              });
              _loadData();
            },
            icon: const Icon(Icons.sort),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortBy.date,
                child: Text("Sort by Newest"),
              ),
              const PopupMenuItem(
                value: SortBy.rating,
                child: Text("Sort by AI Rating"),
              ),
              const PopupMenuItem(
                value: SortBy.votes,
                child: Text("Sort by Votes"),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_ideas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lightbulb_outline, size: 80, color: Colors.yellow),
            const SizedBox(height: 16),
            const Text(
              "No ideas yet!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Be the first to submit a great idea.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _ideas.length,
        itemBuilder: (context, index) {
          final idea = _ideas[index];
          return IdeaCard(
            idea: idea,
            hasVoted: _votedIdeaIds.contains(idea.id),
            onUpvote: () => _upvoteIdea(idea),
          );
        },
      ),
    );
  }
}

class IdeaCard extends StatefulWidget {
  final IdeaModel idea;
  final bool hasVoted;
  final VoidCallback onUpvote;

  const IdeaCard({
    super.key,
    required this.idea,
    required this.hasVoted,
    required this.onUpvote,
  });

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.idea.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.idea.rating}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.idea.tagline,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            AnimatedCrossFade(
              firstChild: Text(
                widget.idea.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(widget.idea.description),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _isExpanded ? "Read less" : "Read more...",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: widget.onUpvote,
                  icon: Icon(
                    widget.hasVoted
                        ? Icons.thumb_up_alt
                        : Icons.thumb_up_alt_outlined,
                  ),
                  label: Text('${widget.idea.voteCount} Votes'),
                  style: TextButton.styleFrom(
                    foregroundColor: widget.hasVoted
                        ? colorScheme.primary
                        : Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
