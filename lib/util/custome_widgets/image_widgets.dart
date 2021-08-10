import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elajkom/util/utility/api_provider.dart';
import 'package:elajkom/util/utility/lunch_url.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import '../custome_widgets/image_view_page.dart';
import '../../util/utility/global_var.dart';

class FileView extends StatelessWidget {
  final dynamic file;
  final double width;
  final double height;
  final double imageWidth;
  final double imageHeight;
  final BoxFit fit;
  final Function onTap;
  final bool tapped;
  final bool crop;

  void onTapFun(BuildContext context) {}

  FileView(
    this.file, {
    this.width = 100,
    this.height = 150,
    this.imageWidth = 300,
    this.imageHeight = 400,
    this.fit = BoxFit.contain,
    this.onTap,
    this.tapped = true,
    this.crop = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: getImageWidget(),
      onTap: tapped
          ? onTap ??
              () {
                if (file is File)
                  LunchUrl.canLaunch(file.path);
                else if (file is PlatformFile)
                  LunchUrl.canLaunch(file.path);
                else
                  LunchUrl.canLaunch(ApiProvider.downloadApi + file);
              }
          : null,
    );
  }

  Widget getImageWidget() {
    if (file != null) {
      if (file is File)
        return SvgPicture.file(file, height: height, width: width, fit: fit);
      else if (file is String && file.isNotEmpty) {
        String url = GlobalVar.getImageUrl(file, width: imageWidth.toInt(), height: imageHeight.toInt(), crop: crop);
        if (file.startsWith('http')) url = file;
        return SvgPicture.network(
          url,
          width: width,
          height: height,
          placeholderBuilder: (context) =>
              Container(color: Colors.grey.shade100, width: width, height: height, child: Center(child: CircularProgressIndicator())),
          fit: fit,
        );
      }
    }

    return Image.asset(GlobalVar.noImage, width: width, height: height, fit: BoxFit.cover);
  }

  ImageProvider<dynamic> getImageProviderWidget() {
    if (file != null) {
      if (file is File)
        return FileImage(file);
      else if (file is String && file.isNotEmpty)
        return NetworkImage(
          file.startsWith('http') ? file : GlobalVar.getImageUrl(file, width: imageWidth?.toInt(), height: imageHeight?.toInt()),
        );
    }
    return AssetImage(GlobalVar.noImage);
  }
}

class ImageView extends StatelessWidget {
  final dynamic image;
  final double width;
  final double height;
  final double imageWidth;
  final double imageHeight;
  final BoxFit fit;
  final Function onTap;
  final bool tapped;
  final bool crop;

  void onTapFun(BuildContext context) {}

  ImageView(
    this.image, {
    this.width = 100,
    this.height = 150,
    this.imageWidth = 300,
    this.imageHeight = 400,
    this.fit = BoxFit.contain,
    this.onTap,
    this.tapped = true,
    this.crop = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // child: FadeInImage(
      //   alignment: Alignment.center,
      //   height: height,
      //   width: width,
      //   image: getImageProviderWidget(),
      //   fit: fit,
      //   placeholder: AssetImage(GlobalVar.logo),
      //   imageErrorBuilder: (context, error, stackTrace) {
      //     // log('///////////////////imageErrorBuilder');
      //     // print(error.toString());
      //     // print(stackTrace.toString());
      //     // log(GlobalVar.getImageUrl(image.toString(), width: width, height: height));
      //     return Image.asset(GlobalVar.noImage, width: width, height: height, color: Colors.black45);
      //   },
      // ),
      child: getImageWidget(),
      onTap: tapped
          ? onTap ??
              () {
                Navigator.pushNamed(context, ImageViewPage.routeName, arguments: image);
              }
          : null,
    );
  }

  Widget getImageWidget() {
    if (image != null) {
      if (image is File)
        return Image.file(image, height: height, width: width, fit: fit);
      else if (image is String && image.isNotEmpty) {
        String url = GlobalVar.getImageUrl(image, width: imageWidth.toInt(), height: imageHeight.toInt(), crop: crop);
        if (image.startsWith('http')) url = image;
        return CachedNetworkImage(
          width: width,
          height: height,
          imageUrl: url,
          placeholder: (context, url) =>
              Container(color: Colors.grey.shade100, width: width, height: height, child: Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) {
            log(url);
            log(error.toString());
            return Image.asset(GlobalVar.noImage, width: width, height: height, fit: BoxFit.cover);
          },
          fit: fit,
        );
      }
    }

    return Image.asset(GlobalVar.noImage, width: width, height: height, fit: BoxFit.cover);
  }

  ImageProvider<dynamic> getImageProviderWidget() {
    if (image != null) {
      if (image is File)
        return FileImage(image);
      else if (image is String && image.isNotEmpty)
        return NetworkImage(
          image.startsWith('http') ? image : GlobalVar.getImageUrl(image, width: imageWidth?.toInt(), height: imageHeight?.toInt()),
        );
    }
    return AssetImage(GlobalVar.noImage);
  }
}

class CircularImageView extends StatelessWidget {
  final dynamic image;
  final double dimension;
  final BoxBorder border;
  final Function onTap;
  final bool tapped;
  final BoxFit fit;
  final EdgeInsets margin;
  final ImageProvider defaultImage;

  void onTapFun(BuildContext context) {}

  CircularImageView(
    this.image, {
    this.dimension = 50,
    this.onTap,
    this.tapped = true,
    this.fit = BoxFit.cover,
    this.border,
    this.margin = const EdgeInsets.all(2),
    this.defaultImage,
  });

  ImageProvider<dynamic> getImageWidget() {
    if (image != null) {
      if (image is File)
        return FileImage(image);
      else if (image is String && image.isNotEmpty)
        return NetworkImage(
          image.startsWith('http') ? image : GlobalVar.getImageUrl(image, width: dimension.toInt() * 2, height: dimension.toInt() * 2),
        );
    }
    return defaultImage ?? AssetImage(GlobalVar.person);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: dimension,
        width: dimension,
        margin: margin,
        decoration: BoxDecoration(
          border: border,
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: fit,
            image: getImageWidget(),
          ),
        ),
      ),
      onTap: tapped
          ? onTap ??
              () {
                Navigator.pushNamed(context, ImageViewPage.routeName, arguments: image);
              }
          : null,
    );
  }
}

class ImageSlider extends StatefulWidget {
  final List<String> imageList;
  final int width;
  final int height;
  final double viewportFraction;
  final bool enlargeCenterPage;
  final bool autoPlay;

  ImageSlider(this.imageList, this.width, this.height, {this.viewportFraction = 0.8, this.enlargeCenterPage = true, this.autoPlay = true});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.imageList.length == 0
            ? Image.asset(GlobalVar.logo, fit: BoxFit.cover, width: widget.width.toDouble(), height: widget.height.toDouble())
            : CarouselSlider(
                items: widget.imageList.map((url) {
                  return Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, ImageViewPage.routeName, arguments: url);
                      },
                      child: Image.network(GlobalVar.getImageUrl(url), width: widget.width.toDouble(), height: widget.height.toDouble()),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  viewportFraction: widget.viewportFraction,
                  autoPlay: widget.autoPlay,
                  // pauseAutoPlayOnTouch: Duration(seconds: 5),
                  enlargeCenterPage: widget.enlargeCenterPage,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageList.map((f) {
              int index = widget.imageList.indexOf(f);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(shape: BoxShape.circle, color: _current == index ? Colors.white70 : Colors.black45),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class FullScreenImageSlider extends StatefulWidget {
  final List<String> imageList;
  final int initImage;
  final double viewportFraction;
  final bool enlargeCenterPage;
  final bool autoPlay;

  FullScreenImageSlider(this.imageList, {this.initImage = 0, this.viewportFraction = 1.0, this.enlargeCenterPage = false, this.autoPlay = true});

  @override
  _FullScreenImageSliderState createState() => _FullScreenImageSliderState();
}

class _FullScreenImageSliderState extends State<FullScreenImageSlider> {
  int _current = 0;

  @override
  void initState() {
    _current = widget.initImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      widget.imageList.length == 0
          ? Image.asset(GlobalVar.logo, fit: BoxFit.cover)
          : Container(
              height: deviceHeight,
              child: CarouselSlider(
                items: widget.imageList.map((url) {
                  return PhotoView(imageProvider: NetworkImage(GlobalVar.getDownloadUrl(url)));
                }).toList(),
                options: CarouselOptions(
                  initialPage: widget.initImage,
                  autoPlay: widget.autoPlay,
                  // pauseAutoPlayOnTouch: Duration(seconds: 10),
                  enlargeCenterPage: widget.enlargeCenterPage,
                  viewportFraction: 1.0,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
            ),
      Positioned(
        top: 0,
        left: 5,
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageList.map((f) {
            int index = widget.imageList.indexOf(f);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(shape: BoxShape.circle, color: _current == index ? Colors.white : Colors.white38),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}
