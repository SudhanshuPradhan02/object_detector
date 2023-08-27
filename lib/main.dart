import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

void main(){
  runApp(
      Myapp()
  );
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  File? imageFile;
  late String result = 'Results will be shown here';
  dynamic imageLabeler;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData( brightness: Brightness.dark),
      home: Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[

                const CircleAvatar(

                  radius: 60.0,
                  backgroundImage: AssetImage('assets/images/lens_find.png'),
                ),
                const Text('OBJECT DETECTOR',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5

                  ),

                ),
                SizedBox(
                  height: 20.0,
                  width: 150.0,
                  child: Divider(
                    thickness: 2.0,
                    color: Colors.teal.shade100,
                  ),
                ),

                ElevatedButton(
                  onPressed: () => getImage(source: ImageSource.gallery) ,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
                  ),
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(5.0),
                    child:  ListTile(
                        leading: const Icon(Icons.photo_album_outlined,
                          color: Colors.black54,),
                        title: Text('Gallery',
                          style: TextStyle(
                              color: Colors.teal.shade900,
                              fontSize:18.0
                          ),
                        )
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: ()=> getImage(source: ImageSource.camera) ,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(5.0),
                    color: Colors.white,
                    child:  ListTile(
                      leading: const Icon(Icons.camera,
                        color: Colors.black54,),
                      title: Text('Camera',

                        style: TextStyle(color: Colors.teal.shade900,
                            fontSize:18.0),
                      ),

                    ),
                  ),
                ),
                if(imageFile!= null)
                  Column(
                    children: [
                      Container(
                        height: 300,
                        width: 300,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(image: FileImage(imageFile!),
                              fit: BoxFit.fill) ,
                        ),
                      ),

                    ],
                  )
                else
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Container(

                      alignment: Alignment.center,
                      color: Colors.grey,
                      child: const Text('A image should apper here'),
                    ),
                  ),
                Center(
                  child: SizedBox(
                    width: 310,
                    height: 169,
                    child: Center(
                      child: Text(result,
                        style: const TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.lightGreenAccent),
                        ),
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );


  }
  void getImage({required ImageSource source}) async{
    final file= await ImagePicker().pickImage(source: source);

    if(file?.path!= null){
      setState(() {
        imageFile =File(file!.path);
        doImageLabelling();
      });
    }


  }

  void doImageLabelling() async{
    InputImage inputImage = InputImage.fromFile(imageFile!);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    result="";
    for (ImageLabel label in labels) {
      final String text = label.label;
      final double confidence = label.confidence;
      result += text+ " [" +confidence.toString().substring(2,4)+ "%] , ";

    }
    imageLabeler.close();
    setState(() {
      result;
    });
  }

}

