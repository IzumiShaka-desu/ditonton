import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'poster_image.dart';
import 'read_more_text_view.dart';

class EpisodeCard extends StatelessWidget {
  const EpisodeCard({
    Key? key,
    required this.episodeNumber,
    required this.name,
    required this.urlImage,
    required this.voteAverage,
    required this.overview,
  }) : super(key: key);

  final int episodeNumber;
  final String name;
  final String urlImage;
  final double voteAverage;
  final String overview;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$episodeNumber. $name",
            style: kSubtitle,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
                child: PosterImage(
                  height: 100,
                  fit: BoxFit.cover,
                  url: urlImage,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: voteAverage / 2,
                            itemCount: 5,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: kMikadoYellow,
                            ),
                            itemSize: 24,
                          ),
                          Text('$voteAverage')
                        ],
                      ),
                      ReadMoreTextView(
                        text: overview,
                        maxCharacter: 80,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
