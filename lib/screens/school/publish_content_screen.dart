import 'package:flutter/material.dart';

class PublishContentScreen extends StatelessWidget {
  const PublishContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Publish New Content',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'Publish events, assign tags, and launch research campaigns.',
            ),
            const SizedBox(height: 48),

            Container(
              constraints: const BoxConstraints(maxWidth: 800),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Content Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter event or campaign title',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: const [
                      DropdownMenuItem(
                        value: 'event',
                        child: Text('Public Event'),
                      ),
                      DropdownMenuItem(
                        value: 'research',
                        child: Text('Research Campaign'),
                      ),
                      DropdownMenuItem(
                        value: 'assignment',
                        child: Text('Assignment Tagging'),
                      ),
                    ],
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Provide details about this content.',
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Target Audience Tags (Skills/Development)'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Python'),
                        onSelected: (val) {},
                      ),
                      FilterChip(
                        label: const Text('Data Analysis'),
                        onSelected: (val) {},
                      ),
                      FilterChip(
                        label: const Text('Design'),
                        onSelected: (val) {},
                      ),
                      ActionChip(
                        label: const Text('+ Add Tag'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Content Published Successfully!'),
                          ),
                        );
                      },
                      child: const Text('Publish Content'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
