import 'dart:math';
import 'package:assignment_app/helper/idea_storage.dart';
import 'package:assignment_app/models/idea_model.dart';
import 'package:assignment_app/screens/idea_listing.dart';
import 'package:assignment_app/screens/leaderboard.dart';
import 'package:flutter/material.dart';

class IdeaSubmission extends StatefulWidget {
  const IdeaSubmission({super.key});

  @override
  State<IdeaSubmission> createState() => _IdeaSubmissionState();
}

class _IdeaSubmissionState extends State<IdeaSubmission> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitIdea() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    final random = Random();
    final fakeAiRating = 60 + random.nextInt(39);
    final newIdea = IdeaModel(
      title: _nameController.text,
      tagline: _taglineController.text,
      description: _descriptionController.text,
      rating: fakeAiRating,
    );
    final storage = IdeaStorage();
    await storage.addIdea(newIdea);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✨ AI analysis complete! Your idea scored a $fakeAiRating!',
          ),
          backgroundColor: Colors.green[700],
        ),
      );
    }
    _formKey.currentState!.reset();
    _nameController.clear();
    _taglineController.clear();
    _descriptionController.clear();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _taglineController.clear();
    _descriptionController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("IDEA SUBMISSION"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.list_alt_rounded),
            tooltip: 'View All Ideas',
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const IdeaListing()));
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.leaderboard_rounded),
              tooltip: 'View Leaderboard',
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const Leaderboard()));
              },
            ),
            const SizedBox(width: 8),
          ],
        ),

        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Submit Your Idea 🚀",
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Let's ideate something amazing together!",
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _nameController,
                  labelText: "Startup Name",
                  colorScheme: colorScheme,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a startup name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _taglineController,
                  labelText: "Tagline",
                  colorScheme: colorScheme,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a tagline.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: "Description",
                  maxLines: 5,
                  colorScheme: colorScheme,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description.';
                    }
                    if (value.length < 20) {
                      return 'Description must be at least 20 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                OutlinedButton(
                  onPressed: _clearForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: colorScheme.error),
                    foregroundColor: colorScheme.error,
                  ),
                  child: const Text(
                    'Clear Form',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _submitIdea,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: const Text(
                    'Submit Idea',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required ColorScheme colorScheme,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: colorScheme.onSurface),
      cursorColor: colorScheme.primary,
      autofocus: false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}
