//model of any project contains what all it will contain

class Notes {
//constructor of class notes
  Notes({
    this.title,//title of notes
    this.noteId,// sub title of notes
    this.password,//password of notes ie content of notes
    this.date,//date when note was created
    this.file,//url of img
    this.name,
    this.id,
    this.isChecked ,
  });

  String ? title;
  String ? noteId;
  String ? password;
  String ? date;
  String ? file;
  String ? name;
  String ? id;
  bool ? isChecked;

  //a constructor function of notes that converts the data from json(firebase)to string   receives a map of json obj as parameter
  Notes.fromJson(Map<String,dynamic> json)
  {
    title = json['note_title'].toString();
    noteId = json['note_subtitle'].toString();
    password = json['note_pass'].toString();
    date = json['date'].toString();
    file = json['note_file'].toString();
    name = json['note_image_name'].toString();
    id ='';//initialize id as empty string  because we dont have a id coming from firebase
    isChecked = false;//its is also not coming from backend it is intialized here as false
  }

  //encoding our data which we are sending to firebase to json as interaction btw app and firebase is initialized through json data only
  //this is a function whose name is toJson its return type is Map where keys are string type and values are of any type
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};//data is a map which is initialized as empty now the maps key value like note_title is assigned the title coming from firebase in json format which has been converted to string in the cons func
    data['note_title'] = title;
    data['note_subtitle'] = noteId;
    data['note_pass'] = password;
    data['date'] = date;
    data['note_file'] = file;
    data['note_image_name'] = name;
    data['isChecked'] = isChecked;
    return data;
    }

}

