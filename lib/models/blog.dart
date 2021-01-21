class Blog {
  String writerID;
  String writer;
  String title;
  String article;
  String writerProfile;


  Blog({this.writerID,this.writer, this.title, this.article,this.writerProfile});

  Map<String, dynamic> toMap(){
    return {
      'writerID' : writerID,
      'writer' : writer,
      'writerProfile' : writerProfile,
      'title' : title,
      'article' : article
    };
  }

  Blog.fromMap(Map<String,dynamic> map) :
      this.writerID = map['writerID'],
      this.writer = map['writer'],
      this.writerProfile = map['writerProfile'],
      this.title = map['title'],
      this.article = map['article'];
}