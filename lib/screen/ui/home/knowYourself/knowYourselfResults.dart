import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/home/knowYourself/knowyourselfintro.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';


class KnowYourselfResults extends StatefulWidget {
  const KnowYourselfResults({super.key});

  @override
  State<KnowYourselfResults> createState() => _KnowYourselfResultsState();
}

class _KnowYourselfResultsState extends State<KnowYourselfResults> {

  List data = [];
  bool loading = true;

  int selectedResult = -1;

  List<Color> pieChartColors = [
    const Color(0xFF3498db), // Blue
    const Color(0xFFe74c3c), // Red
    const Color(0xFF2ecc71), // Green
    const Color(0xFFf39c12), // Orange
    const Color(0xFF9b59b6), // Purple
    const Color(0xFF1abc9c), // Teal
    const Color(0xFF34495e), // Dark Grayish Blue
    const Color(0xFFe67e22), // Carrot Orange
    const Color(0xFF95a5a6), // Grayish Blue
    const Color(0xFFd35400), // Pumpkin
    const Color(0xFFc0392b), // Dark Red
    const Color(0xFF16a085), // Green Sea
    const Color(0xFF8e44ad), // Dark Purple
    const Color(0xFF27ae60), // Nephritis Green
    const Color(0xFF2980b9), // Belize Hole Blue
    const Color(0xFFf1c40f), // Yellow
    const Color(0xFFe74c3c), // Red
    const Color(0xFF2c3e50), // Midnight Blue
    const Color(0xFF3498db), // Peter River Blue
    const Color(0xFFe67e22), // Sunflower Yellow
  ];


  getData()async{
    User user = Provider.of<User>(context,listen: false);
    var lst = await Services(user.token).getKnowYourselfResults();

    setState(() {
      data = lst;
      loading = false;
    });
  }


  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: Components(context).myAppBar(title: 'Know Yourself',titleStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black,fontSize: 19) ,actions: [
        TextButton.icon(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const KnowYourselfIntro())).then((value) => getData());
        }, icon: const Icon(Icons.add),
          label: Text('Take Quiz'),
        ),
      ]),
      body: (loading)
          ? Components(context).Loader(textColor: Colors.black)
          :(data.isEmpty)
          ? Center(
        child: Text("Press '+' to start an assessment",style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),),
      )
          :ListView.builder(
                  itemCount: data.length,
          itemBuilder: (context,index){
          List<PieChartSectionData> pieChartData = List.generate(data[index]['category'].length, (i) => PieChartSectionData(
            title: data[index]['category'][i]['title'],
            value: double.parse(data[index]['category'][i]['marks'].toString()),
            color: pieChartColors[i],
            showTitle: false,
            radius: 100

          ));

          return GestureDetector(
            onTap: (){
              HapticFeedback.mediumImpact();
              setState(() {
                (selectedResult == index)
                    ?selectedResult = -1
                    :selectedResult = index;
              });
            },
            child: Card(
              //color: Colors.redAccent,
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Padding(padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text('Test on ${DateFormat('MMMM dd, yyyy hh:mm a').format(DateTime.parse(data[index]['_id']).toLocal())}',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),
                            )
                        ),
                        CircleAvatar(
                          child: RotatedBox(
                              quarterTurns: (selectedResult == index)?-1:1,
                              child: const Icon(Icons.chevron_right)),
                        )
                      ],
                    ),

                    Visibility(
                      visible: selectedResult == index,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25,),
                          Text('Report:',style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black,),),
                          const SizedBox(height: 15,),
                          AspectRatio(
                            aspectRatio: 1,
                            child: Center(
                                child: PieChartSample(pieChartData)
                            ),
                            /*PieChartSample(pieChartData)*/
                          ),
                          const SizedBox(height: 15,),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: pieChartData.length,
                            itemBuilder: (context, index) {
                              final sectionData = pieChartData[index];
                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: sectionData.color,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        sectionData.title,
                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),
                                      ),
                                    ),
                                    Text(
                                      '${sectionData.value}%',
                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),),
            ),
          );
          }),
    );
  }
}

class PieChartSample extends StatelessWidget {
  final List<PieChartSectionData> data;

  const PieChartSample(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        PieChartData(
          sections: data,
          centerSpaceRadius: 30.0,
          borderData: FlBorderData(show: false),
          sectionsSpace: 5,
        ),
      ),
    );
  }

}
