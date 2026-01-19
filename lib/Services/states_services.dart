import 'dart:convert';

import 'package:covid19_app/Model/WorldStatesModel.dart';
import 'package:covid19_app/Services/Utilities/app_urls.dart';

import 'package:http/http.dart'as http;
class StatesServices {
  Future<WorldStatesModel>fetchWorldStatesRecords() async{
    final response= await http.get(Uri.parse(AppUrls.worldStatesApi));
    if(response.statusCode==200){
      var data=jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    }else{
      throw Exception('Error');
    }
  }

  Future<List<dynamic>>countriesListApi() async{
    final response= await http.get(Uri.parse(AppUrls.countriesList));
    if(response.statusCode==200){
      var data=jsonDecode(response.body);
      return data;
    }else{
      throw Exception('Error');
    }
  }
}