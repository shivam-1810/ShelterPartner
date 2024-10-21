import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shelter_partner/models/animal.dart';

class AnimalsAnimalDetailPage extends StatelessWidget {
  final Animal animal;

  const AnimalsAnimalDetailPage({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    // Helper method to format the intake date
    String getFormattedDate(Timestamp? timestamp) {
      if (timestamp == null) return 'Unknown';
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }

    void showFullScreenImage(BuildContext context, String imageUrl) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: Colors.black,
            body: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Image.network(imageUrl),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name), // Display the animal's name at the top
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photos in a horizontal scrollable slideshow view
            SizedBox(
              height: 200.0, // Adjust the height as needed
              child: animal.photos.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: animal.photos.length,
                      itemBuilder: (context, index) {
                        final photo = animal.photos[index];
                        final scaledUrl = photo.url.replaceFirst('.jpeg',
                            '_250x250.jpeg'); // Assuming the image format is always .jpeg
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () =>
                                showFullScreenImage(context, photo.url),
                            child: Image.network(
                              scaledUrl, // Use the scaled down version of the image
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No photos available'),
                      ),
                    ),
            ),
            const SizedBox(height: 16.0),

            // Animal details section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Name'),
              subtitle: Text(animal.name),
            ),
            ListTile(
              title: const Text('Age'),
              subtitle: Text(animal.age),
            ),
            ListTile(
              title: const Text('Sex'),
              subtitle: Text(animal.sex),
            ),
            ListTile(
              title: const Text('Species'),
              subtitle: Text(animal.species),
            ),
            ListTile(
              title: const Text('Breed'),
              subtitle: Text(animal.breed),
            ),
            ListTile(
              title: const Text('Description'),
              subtitle: Text(animal.description),
            ),
            ListTile(
              title: const Text('Intake Date'),
              subtitle: Text(getFormattedDate(animal.intakeDate)),
            ),
            const SizedBox(height: 16.0),

            // Notes section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Notes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            animal.notes.isNotEmpty
                ? Column(
                    children: animal.notes.map((note) {
                      return ListTile(
                        title: Text(note.note ?? 'Note'),
                      );
                    }).toList(),
                  )
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No notes available'),
                  ),

// Logs section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Logs',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            animal.logs.isNotEmpty
                ? Column(
                    children: animal.logs.map((log) {
                      return ListTile(
                        title: Text(log.id ?? 'Log'),
                      );
                    }).toList(),
                  )
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No logs available'),
                  ),
          ],
        ),
      ),
    );
  }
}