import 'package:covid19_app/Model/WorldStatesModel.dart';
import 'package:covid19_app/Services/states_services.dart';
import 'package:covid19_app/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
class WorldStates extends StatefulWidget {
  const WorldStates({super.key});

  @override
  State<WorldStates> createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates>with TickerProviderStateMixin {
  late final AnimationController _controller=AnimationController(
      duration: Duration(seconds: 3),
      vsync: this
  )..repeat();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  final colorList=<Color>[
    Color(0xff4285f4),
    Color(0xff1aa260),
    Color(0xffde5246),
  ];
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices=StatesServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height *.01,),
                      FutureBuilder(
                        future: statesServices.fetchWorldStatesRecords(),
                          builder: (context,AsyncSnapshot<WorldStatesModel> snapshot){
                        if(!snapshot.hasData){
                          return Expanded(
                            flex: 1,
                              child: SpinKitFadingCircle(
                                color: Colors.white,
                                size: 50,
                                controller: _controller,
                              ));
                        }else{
                          return Column(
                            children: [
                              PieChart(
                                dataMap:{
                                  "Total":double.parse(snapshot.data!.cases!.toString()),
                                  "Recovered":double.parse(snapshot.data!.cases!.toString()),
                                  "Deaths":double.parse(snapshot.data!.cases!.toString()),
                                },
                                chartRadius: MediaQuery.of(context).size.width/3.2,
                                legendOptions: LegendOptions(
                                  legendPosition: LegendPosition.left,
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValuesInPercentage: true
                                ),
                                animationDuration: Duration(milliseconds: 1200),
                                chartType: ChartType.ring,
                                colorList: colorList,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height *.06),
                                child: Card(
                                  child: Column(
                                    children: [
                                      ReuseableRow(title: 'Total', value:snapshot.data!.cases.toString() ),
                                      ReuseableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                                      ReuseableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                                      ReuseableRow(title: 'Critical', value: snapshot.data!.critical.toString()),
                                      ReuseableRow(title: 'Tests', value: snapshot.data!.tests.toString()),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CountriesList()));
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xff1aa260),

                                  ),
                                  child: Center(
                                      child: Text('Track Countries')),
                                ),
                              )
                            ],
                          );
                        }
                      }),

                    ],
                  ),
          ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  final String title;
  final String value;

  const ReuseableRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
            Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider()
        ],
      ),
    );
  }
}
