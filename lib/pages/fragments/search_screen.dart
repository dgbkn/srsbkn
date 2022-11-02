import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:srsbkn/pages/api/apiEndpoints.dart';
import 'package:srsbkn/pages/player/main_player.dart';
import 'package:srsbkn/theme/app_theme.dart';
import 'package:srsbkn/theme/theme_type.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  TabController? _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  bool showProg = false;
  var searchCards = <Container>[];

  Widget _buildSingleSong(song) {
    return FxContainer(
      margin: FxSpacing.bottom(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MusicPlayer(
                    songInfo: song,
                  )),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FxContainer(
            paddingAll: 0,
            clipBehavior: Clip.hardEdge,
            child: Image(
              height: 80,
              width: 80,
              fit: BoxFit.fill,
              image: AssetImage("assets/gurujii.jpg"),
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FxText.bodyLarge(
                        song["title"],
                        fontWeight: 600,
                      ),
                    ),
                    // Icon(
                    //   FeatherIcons.heart,
                    //   color: theme.colorScheme.primary,
                    //   size: 20,
                    // ),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.description,
                      size: 16,
                    ),
                    FxSpacing.width(8),
                    Expanded(
                        child: FxText.bodySmall(
                      song["description"],
                      xMuted: true,
                    )),
                  ],
                ),
                FxSpacing.height(6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future loadSearch(qry) async {
    setState(() {
      showProg = true;
    });
    searchCards = <Container>[];
    var data = await get(getApiUrl("searchsongs.php?query=$qry"));

    var gotData = jsonDecode(data.body);

    if (gotData.length == 0) {
      searchCards.add(Container(
        child: const Center(child: Text("Nothing Found on server")),
      ));
    } else {
      gotData["data"].forEach((data) {
        searchCards.add(Container(child: _buildSingleSong(data)));
      });
    }

    if (mounted) {
      setState(() {
        showProg = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return _buildMainBody(size);
            },
          ),
        ),
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
  ) {
    bool isDark = AppTheme.themeType == ThemeType.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Center(
          //   child: Image.asset(
          //     'assets/img/logo/splash_logo.png',
          //     height: 200,
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20),
            child: Text('Seach.',
                style: GoogleFonts.montserrat(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'For Bhajans/Dhuns/Ramayan/Amritwani... 🪔',
              style: GoogleFonts.montserrat(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// username or Gmail
                  TextFormField(
                    // style: kTextFormFieldStyle(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Enter Your Query',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    controller: nameController,
                    onFieldSubmitted: ((value) => loadSearch(value)),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter search';
                      } else if (value.length < 3) {
                        return 'at least enter 3 characters';
                      } else if (value.length > 50) {
                        return 'maximum character is 50';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: size.height * 0.02,
                  ),


                  /// searchButton Button
                  searchButton(),

                  searchCards.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            children: [SizedBox(height: 5,),...searchCards],
                          ),
                        )
                      : SizedBox(),

                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  /// Navigate To Login Screen
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // searchButton Button
  Widget searchButton() {
        bool isDark = AppTheme.themeType == ThemeType.dark;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            // setState(() {
            //   showProg = true;
            // });
            // ... Login To your Home Page
            loadSearch(nameController.value.text);
          }
        },
        child: Row(
          children: [
            showProg
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(),
             Text('Search', style: GoogleFonts.montserrat(
                    color: isDark ? Colors.white : Colors.black,
                    // fontSize: 25.0,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
