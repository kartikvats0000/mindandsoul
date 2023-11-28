import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindandsoul/helper/components.dart';
import 'package:mindandsoul/provider/userProvider.dart';
import 'package:mindandsoul/screen/ui/home/talk_to_me/talktomeintro.dart';
import 'package:mindandsoul/services/services.dart';
import 'package:provider/provider.dart';

class TalkToMeResults extends StatefulWidget {
  const TalkToMeResults({super.key});

  @override
  State<TalkToMeResults> createState() => _TalkToMeResultsState();
}

class _TalkToMeResultsState extends State<TalkToMeResults> {


  List data = [];
  bool loading  = true;

  getData()async{
    User user = Provider.of<User>(context,listen : false);
    var lst = await Services(user.token).getTalkToMeSessionsList();

    setState(() {
      data = lst;
      data = data.reversed.toList();
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: Components(context).myAppBar(title: 'Talk To Me',
          titleStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black,fontSize: 21),
          actions: [
        TextButton.icon(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TalktomeIntro())).then((value) => getData());
        }, icon: const Icon(Icons.add), label: Text('Request'),),
      ]
      ),
      body: (loading)
          ?Components(context).Loader(textColor: Colors.black)
          :(data.isEmpty)
          ? Center(
        child: Text("Press '+' to request a session",style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),),
      )
          : RefreshIndicator(
        onRefresh: ()async{
          await getData();
        },
            child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: data.length,
            itemBuilder: (context,index){
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              padding: const EdgeInsets.fromLTRB(15,15,15,0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(child:
                      Text(DateFormat('MMMM dd, yyyy hh:mm a').format(DateTime.parse(data[index]['createdAt']).toLocal()),style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black,fontSize: 14.5),),
                      ),
                      Text(
                          "Status: ${data[index]['status']}",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: _getStatusColor(data[index]['status'],context),fontSize: 13)
                      ),
                    ],
                  ),
                  Visibility(
                    visible: data[index]['status'] == 'Rejected',
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Text('Reason of Rejection: ',style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black,fontSize: 13,decoration: TextDecoration.underline),),
                            //const SizedBox(height: 5,),
                            Text('${data[index]['desc']}',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),),
                          ],
                        ),
                      )
                  ),
                  Visibility(
                    visible: data[index]['status'] == 'Scheduled' && data[index]['url'] == '',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Meeting scheduled on: ',style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black,fontSize: 13,decoration: TextDecoration.underline),),
                                  const SizedBox(height: 2,),
                                  Text(DateFormat('dd/MM/yy, hh:mm a').format(DateTime.parse(data[index]['createdAt']).toLocal()),style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: data[index]['isActive'] ?? false,
                                child: FilledButton.tonal(onPressed: (){}, child: const Text('Join Meeting'))),
                          ],
                        ),
                      )
                  ),
                  const SizedBox(height: 15,),
                  Visibility(
                    visible: data[index]['status'] != 'Completed' && data[index]['status'] != 'Rejected',
                    child: TextButton(
                        onPressed: (){},
                        child: Text('Cancel'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: Colors.redAccent
                      ),
                    ),
                  )
                ],
              ),
            );
            }
                  ),
          )
    );
  }
  Color _getStatusColor(String status,BuildContext context) {
    switch (status) {
      case 'Completed':
        return const Color(0xff4CAF50);
      case 'Rejected':
        return const Color(0xffff5d4f);
    // Add more status colors if needed
      case 'Scheduled':
        return Colors.orangeAccent;
      case 'Requested':
        return Theme.of(context).colorScheme.primary;
      case 'Cancelled':
        return Colors.redAccent;
      default:
        return Colors.black;
    }
  }
}