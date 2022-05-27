import 'package:flutter/material.dart';
// import 'package:meilisearch/meilisearch.dart';
// import 'package:cached_network_image/cached_network_image.dart';


class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // var client = MeiliSearchClient('http://54.159.59.74/', 'masterKey');
  // List? searchs;
  // searchItems(String searched) {
  //   setState(() {
  //     client
  //         .index('movie')
  //         .search(searched,limit: 8)
  //         .then((value) => searchs = value.hits);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final WIDTH = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 247, 242, 1),
      appBar: AppBar(
        titleSpacing: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: TextField(
          onChanged: (change) {
            // searchItems(change);
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          minLines: 1,
          maxLines: 1,
          cursorColor: Theme.of(context).colorScheme.primary,
          decoration: InputDecoration(
            hintText: 'Search for...',
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            border:const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      // body: SafeArea(
      //   child: searchs != null
      //       ? ListView.builder(
      //           itemCount: searchs!.length,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               leading:CachedNetworkImage(
      //                   imageUrl:
      //                       searchs![index]['poster'],
      //                   errorWidget: (context, url, error) => Text("error"),
      //                   placeholder: (context, url) =>
      //                       CircularProgressIndicator(
      //                     color: Theme.of(context).colorScheme.primary,
      //                   ),
      //                   imageBuilder: (context, imageProvider) => ClipRRect(
      //                     borderRadius: BorderRadius.circular(8),
      //                     child: Image(image: imageProvider,width: 50,height: 50,fit: BoxFit.cover,),
      //                   ))   ,
      //               title: Text(searchs![index]['title'],style: TextStyle(color: Theme.of(context).colorScheme.primary),),
      //               subtitle: Text(searchs![index]['id'],style: TextStyle(color: Theme.of(context).colorScheme.primary),),
      //             );
      //           })
      //       : Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text('No search match',style: Theme.of(context).textTheme.titleMedium,),
                    
      //             ],
      //           ),
      //       ),
      // ),
    );
  }
}
