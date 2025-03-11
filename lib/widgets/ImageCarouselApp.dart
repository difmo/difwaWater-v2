import 'package:difwa/config/app_color.dart';
import 'package:difwa/utils/app__text_style.dart';
import 'package:flutter/material.dart';

class ImageCarouselPage extends StatefulWidget {
  const ImageCarouselPage({super.key});

  @override
  State<ImageCarouselPage> createState() => _ImageCarouselPageState();
}

class _ImageCarouselPageState extends State<ImageCarouselPage> {
  final CarouselController controller = CarouselController(initialItem: 1);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: height / 5.5),
            child: CarouselView.weighted(
              controller: controller,
              itemSnapping: true,
              flexWeights: const <int>[1, 6, 1],
              children: ImageInfo.values.map((ImageInfo image) {
                return HeroLayoutCard(imageInfo: image);
              }).toList(),
            ),
          ),
        ],
      ),
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
            maxWidth: width * 1.9,
            minWidth: width * 1.9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/cardbg8.png'), // Using local assets
                    fit: BoxFit.contain, // You can change this as needed
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColors.mywhite,
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3)),
                  ]),
              // child: Image(
              //   fit: BoxFit.contain,
              //   image: AssetImage('${imageInfo.url}'), // Using local assets
              // ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                imageInfo.title,
                overflow: TextOverflow.clip,
                softWrap: false,
                style:
                    AppTextStyle.Text28600.copyWith(color: AppColors.mywhite),
                textAlign: TextAlign.center,
              ),
              Text(
                imageInfo.subtitle,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Color(0xFF750F0F),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum ImageInfo {
  image0('Drips Springs', 'Bottle water delivery | Season 1 Now Streaming',
      'assets/scollerimg/image0.jpg'),
  image1(
    'Through the Pane',
    'Sponsored | Season 1 Now Streaming',
    'assets/scollerimg/image1.png',
  ),
  image2('Iridescence', 'Sponsored | Season 1 Now Streaming',
      'assets/scollerimg/image2.png'),
  image3('Sea Change', 'Sponsored | Season 1 Now Streaming',
      'assets/images/water.jpg'),
  image4('Blue Symphony', 'Sponsored | Season 1 Now Streaming',
      'assets/images/water.jpg'),
  image5('When It Rains', 'Sponsored | Season 1 Now Streaming',
      'assets/images/water.jpg');

  const ImageInfo(this.title, this.subtitle, this.url);
  final String title;
  final String subtitle;
  final String url;
}
