class Banners {
  int id;
  String titleEn;
  String titleAr;
  String titleTr;
  String title;
  String descriptionEn;
  String descriptionAr;
  String descriptionTr;
  String description;
  String url;
  bool active;
  String featuredImage;
  String featuredImageMobile;
  String createdDate;
  int bannerLocation;

  Banners(
      {this.id,
      this.titleEn,
      this.titleAr,
      this.titleTr,
      this.title,
      this.descriptionEn,
      this.descriptionAr,
      this.descriptionTr,
      this.description,
      this.url,
      this.active,
      this.featuredImage,
      this.featuredImageMobile,
      this.createdDate,
      this.bannerLocation});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['titleEn'];
    titleAr = json['titleAr'];
    titleTr = json['titleTr'];
    title = json['title'];
    descriptionEn = json['descriptionEn'];
    descriptionAr = json['descriptionAr'];
    descriptionTr = json['descriptionTr'];
    description = json['description'];
    url = json['url'];
    active = json['active'];
    featuredImage = json['featuredImage'];
    featuredImageMobile = json['featuredImageMobile'];
    createdDate = json['createdDate'];
    bannerLocation = json['bannerLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titleEn'] = this.titleEn;
    data['titleAr'] = this.titleAr;
    data['titleTr'] = this.titleTr;
    data['title'] = this.title;
    data['descriptionEn'] = this.descriptionEn;
    data['descriptionAr'] = this.descriptionAr;
    data['descriptionTr'] = this.descriptionTr;
    data['description'] = this.description;
    data['url'] = this.url;
    data['active'] = this.active;
    data['featuredImage'] = this.featuredImage;
    data['featuredImageMobile'] = this.featuredImageMobile;
    data['createdDate'] = this.createdDate;
    data['bannerLocation'] = this.bannerLocation;
    return data;
  }
}
