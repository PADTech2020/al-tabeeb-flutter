class Specialty {
  int id;
  String titleAr;
  String titleEn;
  String titleTr;
  String title;
  int doctorsCount;
  String featuredImage;
  bool isFeatured;
  bool isHome;

  Specialty({this.id, this.titleAr, this.titleEn, this.titleTr, this.title, this.doctorsCount, this.featuredImage, this.isFeatured, this.isHome});

  Specialty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleAr = json['titleAr'];
    titleEn = json['titleEn'];
    titleTr = json['titleTr'];
    title = json['title'];
    doctorsCount = json['doctorsCount'];
    featuredImage = json['featuredImage'];
    isFeatured = json['isFeatured'];
    isHome = json['isHome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titleAr'] = this.titleAr;
    data['titleEn'] = this.titleEn;
    data['titleTr'] = this.titleTr;
    data['title'] = this.title;
    data['doctorsCount'] = this.doctorsCount;
    data['featuredImage'] = this.featuredImage;
    data['isFeatured'] = this.isFeatured;
    data['isHome'] = this.isHome;
    return data;
  }

  @override
  String toString() {
    return title;
  }
}
