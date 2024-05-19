import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:se_admin/views/screens/side_bar_screens/buyers_screen.dart';
import 'package:se_admin/views/screens/side_bar_screens/categories_screen.dart';
import 'package:se_admin/views/screens/side_bar_screens/dashboard_screen.dart';
import 'package:se_admin/views/screens/side_bar_screens/deliver_screen.dart';
import 'package:se_admin/views/screens/side_bar_screens/price_chart_screen.dart';
import 'package:se_admin/views/screens/side_bar_screens/products_screen.dart';
import 'package:se_admin/views/screens/side_bar_screens/upload_banner_screen.dart';
import 'package:se_admin/views/screens/side_bar_screens/vendors_screen.dart';
import 'package:se_admin/views/screens/side_bar_screens/withdrawal_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Widget _selectedItem = DashboardScreen();


  screenSlector(item){
    switch (item.route){
      case DashboardScreen.routeName:
      setState(() {
        _selectedItem=DashboardScreen();
      });
      break;
      case BuyersScreen.routeName:
      setState(() {
        _selectedItem=BuyersScreen();
      });
      break;
      case VendorsScreen.routeName:
      setState(() {
        _selectedItem=VendorsScreen();
      });
      break;
      case DeliverScreen.routeName:
      setState(() {
        _selectedItem=DeliverScreen();
      });
      break;
      case PriceChartScreen.routeName:
      setState(() {
        _selectedItem=PriceChartScreen();
      });
      break;
 //     case CategoriesScreen.routeName:
   //   setState(() {
     //   _selectedItem=CategoriesScreen();
  //    });
  //    break;
   //   case ProductScreen.routeName:
    //  setState(() {
    //    _selectedItem=ProductScreen();
    //  });
    //  break;
      case UploadBannerScreen.routeName:
      setState(() {
        _selectedItem=UploadBannerScreen();
      });
      break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Management'),
      ),


      sideBar: SideBar(items:  [
        AdminMenuItem(title: 'Dashboard', icon: Icons.dashboard,route: DashboardScreen.routeName,),
         AdminMenuItem(title: 'Buyers', icon: CupertinoIcons.person,route: BuyersScreen.routeName,),
         AdminMenuItem(title: 'Vendors', icon: CupertinoIcons.person,route: VendorsScreen.routeName,),
          AdminMenuItem(title: 'Deliver Persons', icon: CupertinoIcons.person,route: DeliverScreen.routeName,),
         // AdminMenuItem(title: 'Withdrawal', icon: CupertinoIcons.money_dollar,route: VendorScreen.routeName,),
           AdminMenuItem(title: 'Price Chart', icon: CupertinoIcons.shopping_cart,route: PriceChartScreen.routeName,),
           // AdminMenuItem(title: 'Category', icon: Icons.category,route: CategoriesScreen.routeName,),
             //AdminMenuItem(title: 'Products', icon: Icons.shop,route: ProductScreen.routeName,),
             AdminMenuItem(title: 'Upload Banners', icon: CupertinoIcons.add,route: UploadBannerScreen.routeName,),
      ],
       selectedRoute: '', 
       onSelected: (item){
        screenSlector(item);
      },

      header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'SE Admin Panel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      
      body: _selectedItem
      );
  }
}