import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uber_clone/services/firebase/authentication/authentication_client.dart';


class TempDirectoryService {

   Future<File?> loadUserPicture() async {
    final Directory temp = await getTemporaryDirectory();
    final File profilePicture = File('${temp.path}/${AuthenticationClient.id}');

    //profile picture is in the temp directory
    if(await profilePicture.exists()) {
      print('SLIKA POSTOJI LOKALNO');
        return profilePicture;
    }
    print('SLIKA NE POSTOJI LOKALNO');
    //picture does not exist, return null
    return null;
  }

  static Future<bool> picturesExists() async {
     try {
       final Directory temp = await getTemporaryDirectory();
       File picture = File('${temp.path}/${FirebaseAuth.instance.currentUser!.uid}');

       if(await picture.exists())
         return true;

       return false;

     }
     catch(err) {
       return false;
     }
  }


  static Future<File?> storeUserPicture(Uint8List list) async {
    try {
      final Directory temp = await getTemporaryDirectory();
      File picture = File('${temp.path}/${FirebaseAuth.instance.currentUser!.uid}');

      if(await picture.exists()) {
        print('Profile picture for ' + FirebaseAuth.instance.currentUser!.uid + ' account is already cached');
        await picture.delete();
      }

      return await picture.writeAsBytes(list);
    }
    catch(err) {
      print('There was an error storing the user profile picture');
      print(err.toString());
      return null;
    }
  }




   Future<Map<String, File>?> loadDriversPictures() async {
    final Directory temp = await getTemporaryDirectory();
    Map<String, File> map = {};

   try {
     Directory x = Directory(temp.path + '/drivers');

     if( await x.exists()) {
       List<FileSystemEntity> files = x.listSync();
       files.forEach((element) {
         print(element.path);
         map[element.path.split('/').last] = File(element.path);
       });
     }
     else {
       await createDriverDirectory();
     }
   }
   catch(err) {
     print('error while reading all pictures');
     return null;
   }
    return map;
  }


  Future<File?> loadDriverPicture(String driverId) async {
    try {
      final Directory temp = await getTemporaryDirectory();
      final File file = File('${temp.path}/drivers/$driverId');
      return file;
    }
    catch(err) {
      print('error while loading single driver picture');
      return null;
    }
  }

  static Future<File?> storeDriverPicture(String driverId, Uint8List list) async {

   try {
     final Directory temp = await getTemporaryDirectory();
     File x = File('${temp.path}/drivers/$driverId');

     if(await x.exists()) {
       print('FILE ALREADY EXISTS');
       return await x.writeAsBytes(list);
     }
     else {
       print('FILE DOESNT EXIST');
       File created = await x.create(recursive: true);
       return await created.writeAsBytes(list);
     }
   }
   catch(err) {
     print('error while storing driver picture');
     return null;
   }



  }

  static Future<void> createDriverDirectory() async {
    try {
      final Directory temp = await getTemporaryDirectory();
      await Directory('${temp.path}/drivers').create();
    }
    catch(err) {
      print('error while creating drivers directory');
    }
  }

  Future<void> deleteDriverDirectory() async {
     try {
       final Directory temp = await getTemporaryDirectory();
       await Directory('${temp.path}/drivers').delete(recursive: true);
       print('Uspješno obrisano');
     }
     catch(err) {
       print('there was an error deleting the driver directory');
      print(err.toString());
     }
  }

  Future<void> deleteUserPicture() async {
     try {
       final Directory temp = await getTemporaryDirectory();
       await Directory('${temp.path}/${FirebaseAuth.instance.currentUser!.uid}').delete(recursive: true);
       print('Uspješno obrisano');
     }
     catch(err) {
       print('there was an error deleting the profile picture');
       print(err.toString());
     }
  }






}