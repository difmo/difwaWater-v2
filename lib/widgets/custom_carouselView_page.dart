import 'package:flutter/material.dart';

void main() => runApp(const CarouselApp());

class CarouselApp extends StatelessWidget {
  const CarouselApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const CarouselExample(),
      ),
    );
  }
}

class CarouselExample extends StatefulWidget {
  const CarouselExample({super.key});

  @override
  State<CarouselExample> createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CarouselExample> {
  final CarouselController controller = CarouselController(initialItem: 1);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;

    return ListView(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: height / 2),
          child: CarouselView.weighted(
            controller: controller,
            itemSnapping: true,
            flexWeights: const <int>[1, 7, 1],
            children: ImageInfo.values.map((ImageInfo image) {
              return HeroLayoutCard(imageInfo: image);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class HeroLayoutCard extends StatelessWidget {
  const HeroLayoutCard({super.key, required this.imageInfo});

  final ImageInfo imageInfo;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        ClipRect(
          child: OverflowBox(
            maxWidth: width * 7 / 8,
            minWidth: width * 7 / 8,
            child: const Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/water.jpg'), // Using asset image
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                imageInfo.title,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                imageInfo.subtitle,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum ImageInfo {
  image0('The Flow', 'Sponsored | Season 1 Now Streaming', 'assets/images/water.jpg'),
  image1('Through the Pane', 'Sponsored | Season 1 Now Streaming', 'assets/images/water.jpg'),
  image2('Iridescence', 'Sponsored | Season 1 Now Streaming', 'assets/images/water.jpg'),
  image3('Sea Change', 'Sponsored | Season 1 Now Streaming', 'assets/images/water.jpg'),
  image4('Blue Symphony', 'Sponsored | Season 1 Now Streaming', 'assets/images/water.jpg'),
  image5('When It Rains', 'Sponsored | Season 1 Now Streaming', 'assets/images/water.jpg');

  const ImageInfo(this.title, this.subtitle, this.url);
  final String title;
  final String subtitle;
  final String url;
}
