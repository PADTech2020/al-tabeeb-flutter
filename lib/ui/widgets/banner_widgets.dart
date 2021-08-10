import 'package:elajkom/util/utility/lunch_url.dart';

import '../../util/custome_widgets/image_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classes/models/banners.dart';

class SingleBannerItem extends StatelessWidget {
  final Banners item;
  SingleBannerItem(this.item);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var imageHeight = size.width * (4 / 3);
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(item.url)) launch(item.url);
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: () {
              if (item.url != null) LunchUrl.canLaunch(item.url);
            },
            child: ImageView(
              item.featuredImageMobile,
              height: imageHeight,
              width: size.width,
              imageHeight: 600,
              imageWidth: 800,
              tapped: false,
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   color: Colors.black26,
          //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          //   child: Text(
          //     item.title ?? "",
          //     maxLines: 5,
          //     textAlign: TextAlign.center,
          //     softWrap: true,
          //     style: CustomTheme.title1.copyWith(color: Colors.white),
          //   ),
          // )
        ],
      ),
    );
  }
}
