
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/news_models/db_bookmark_model/bookmark_model.dart';
import 'package:instanews_pro/notification_service/notification_service.dart';
import 'package:instanews_pro/riverpod/db_riverpod/db_riverpod.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/widgets/animated_container_widget/animatedContainerWidget.dart';
import 'package:instanews_pro/widgets/news_details_screen/news_details.dart';
import 'package:instanews_pro/widgets/news_webview/news_webview.dart';
import 'package:instanews_pro/widgets/toast_msg/toast_msg.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

final dateProvider = StateProvider<DateTime>((ref)=>DateTime.now());
final isSelected = StateProvider<bool>((ref)=>false);

final reminderDate = StateProvider<DateTime>((ref)=>DateTime.now());
final reminderTime = StateProvider<TimeOfDay>((ref)=>TimeOfDay.now());

final isReminderDateSet = StateProvider<bool>((ref)=>false);
final isReminderTimeSet = StateProvider<bool>((ref)=>false);


class Bookmarks extends ConsumerStatefulWidget {
  final BookmarkModel? bookmarkModel;
  const Bookmarks({this.bookmarkModel,super.key});

  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends ConsumerState<Bookmarks> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(bookmarkProvider.notifier).getAllBookMarks();
    });
    super.initState();
  }


  void toggleBookmark(BookmarkModel model) async {
    final bookmark = ref.read(bookmarkProvider.notifier);
    final isMarked = await bookmark.hasBookmark(model.id);

    if (isMarked) {
      await bookmark.removeBookmark(model.id);
    } else {
      await bookmark.addToBookmark(model);
    }
  }

  void readLater(BookmarkModel bookmark)async{

    final theme = Theme.of(context);

    showDialog(
        context: context,
        builder: (BuildContext context){
          return Consumer(
              builder: (context,ref, _){
                final selectedDate = ref.watch(reminderDate);
                final selectedTime = ref.watch(reminderTime);

                final isSelectedDate = ref.watch(isReminderDateSet);
                final isSelectedTime = ref.watch(isReminderTimeSet);

                return AlertDialog(
                  title: Text('When Should We Remind You?',style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.date_range,color: theme.iconTheme.color,),
                          SizedBox(width: 5.w,),
                          TextButton(
                              onPressed: ()async{
                                DateTime? date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: isSelectedDate? selectedDate : DateTime.now(),
                                    lastDate: DateTime(2100)
                                );
                                if(date!=null && date!=selectedDate){
                                  ref.read(reminderDate.notifier).state = date;
                                  ref.read(isReminderDateSet.notifier).state = true;
                                }
                              },
                              child: isSelectedDate? Text('Tap to change the date',style: theme.textTheme.titleMedium,) :Text('Tap to select a date',style: theme.textTheme.titleMedium,)
                          )
                        ],
                      ),
                      isSelectedDate?SizedBox(height: 10.h,):SizedBox.shrink(),
                      isSelectedDate? Row(
                        children: [
                          Text('Selected date is : ',style: theme.textTheme.titleMedium,),
                          SizedBox(width: 5.w,),
                          Text('${DateFormat('dd/MM/yyyy').format(selectedDate)}',style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary))
                        ],
                      ) : SizedBox.shrink(),
                      SizedBox(height: 10.h,),
                      Row(
                        children: [
                          Icon(Icons.watch_later_outlined,color: theme.iconTheme.color,),
                          SizedBox(width: 5.w,),
                          TextButton(
                              onPressed: ()async{
                                TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: isSelectedTime? selectedTime : TimeOfDay.now()
                                );
                                if(time!=null && time!=selectedTime){
                                  ref.read(reminderTime.notifier).state = time;
                                  ref.read(isReminderTimeSet.notifier).state = true;
                                }
                              },
                              child: isSelectedTime? Text('Tap to change the time',style: theme.textTheme.titleMedium,) :Text('Tap to select a time',style: theme.textTheme.titleMedium,)
                          )
                        ],
                      ),
                      isSelectedTime?SizedBox(height: 10.h,):SizedBox.shrink(),
                      isSelectedTime? Row(
                        children: [
                          Text('Selected time is : ',style: theme.textTheme.titleMedium,),
                          SizedBox(width: 5.w,),
                          Text('${selectedTime.format(context)}',style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary))
                        ],
                      ) : SizedBox.shrink(),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Cancel',style: theme.textTheme.titleMedium,)
                    ),
                    TextButton(
                        onPressed: (){
                          NotificationService.showNotificationAt(
                              id: bookmark.id.hashCode.abs(),
                              title: '🔔 News Reminder',
                              description: bookmark.title,
                              date: ref.read(reminderDate),
                              time: ref.read(reminderTime)
                          );
                          Navigator.pop(context);
                          ToastMsg.successToast(message: 'Reminder Set Up Successfully', context: context);
                        },
                        child: Text('Set Reminder',style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),)
                    ),
                  ],
                );
              }
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;
    final bookmarkState = ref.watch(bookmarkProvider);

    final displayResult = _searchController.text.isNotEmpty? bookmarkState.searchBookmarks
        : bookmarkState.selectedDateTime!=null? bookmarkState.filteredResult
        : bookmarkState.bookmarks;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 70.h,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark? Brightness.light:Brightness.dark,
            systemNavigationBarColor: isDark ? Color(0xFF121212) : Color(0xFFFFFFFF)
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h,),
          _buildSearchBar(theme,ref),
          SizedBox(height: 20.h,),

          if(bookmarkState.selectedDateTime!=null)
            ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text('Showing Filtered Results',style: theme.textTheme.titleLarge,),
                    Spacer(),
                    IconButton(
                        onPressed: (){
                          ref.read(bookmarkProvider.notifier).clearFilter();
                        },
                        icon: Icon(Icons.change_circle,color: theme.iconTheme.color,size: 30,)
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.h,),
            ],
          Expanded(
             child: Builder(
                 builder: (context){
                   if(displayResult.isEmpty){
                     return Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Center(child: Image.asset('assets/empty.png',fit: BoxFit.cover,width: 250.w,height: 250.h,)),
                         SizedBox(height: 15.h,),
                         Center(child: Text('Oops! No bookmarks are added yet',style: theme.textTheme.titleMedium,)),
                       ],
                     );
                   }
                   return ListView.builder(
                       physics: ClampingScrollPhysics(),
                       shrinkWrap: true,
                       itemCount: displayResult.length,
                       itemBuilder: (context,index){
                         final data = displayResult[index];
                         final bookmarkModel = BookmarkModel(
                             id: data.id,
                             title: data.title,
                             description: data.description,
                             imageUrl: data.imageUrl,
                             categories: data.categories,
                             countries: data.countries,
                             newsUrl: data.newsUrl,
                             newsSource: data.newsSource,
                             sourceIcon: data.sourceIcon,
                             dateTime: data.dateTime
                         );
                         return AnimatedContainerWidget(
                           index: index,
                           offset: Offset(0, 0.5),
                           child: BookmarkWidget(
                             theme: theme,
                             imageUrl: data.imageUrl,
                             title: data.title,
                             chipTitle: data.categories.take(1).map((i)=>i.toUpperCase()).join(''),
                             onBookmark: (){
                               toggleBookmark(data);
                               ToastMsg.errorToast(message: 'Removed From Bookmark', context: context);
                             },
                             onReadLater: (){
                               readLater(bookmarkModel);
                             },
                             isMarked: true,
                             onPressed: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                   NewsDetailPage(
                                       tag: data.id,
                                       imageUrl: data.imageUrl,
                                       category: data.categories.take(1).map((i)=>i.toUpperCase()).join(''),
                                       title: data.title,
                                       source: data.newsSource,
                                       content: data.description,
                                       sourceIcon: data.sourceIcon,
                                       dateTime: data.dateTime!,
                                       model: bookmarkModel,
                                       onShare: (){
                                         SharePlus.instance.share(
                                             ShareParams(
                                                 uri: Uri.parse(data.newsUrl)
                                             )
                                         );
                                       },
                                       onReadLater: (){

                                       },
                                       onReadMore: (){
                                         Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsWebview(newsUrl: data.newsUrl)));
                                       }
                                   )));
                             },
                           ),
                         );
                       }
                   );
                 }
             )
         )
        ],
      ),
    );
  }
  Widget _buildSearchBar(ThemeData theme, WidgetRef ref) {
    final notifier = ref.read(bookmarkProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:20.w ),
      child: Container(
        width: double.infinity.w,
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: TextField(
            controller: _searchController,
            cursorColor: theme.colorScheme.primary,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              hintText: 'Find in bookmarks',
              hintStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Consumer(
                        builder: (context, ref, _) {

                          final selectedDate = ref.watch(dateProvider);
                          final isDateSelected = ref.watch(isSelected);

                          return AlertDialog(
                            title: Text(
                              'Filter By Date',
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(color: theme.colorScheme.primary),
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.date_range, color: theme.iconTheme.color),
                                    SizedBox(width: 5.w),
                                    TextButton(
                                      onPressed: () async {
                                        DateTime? date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime.now(),
                                          initialDate: isDateSelected? selectedDate : DateTime.now(),
                                        );
                                        if (date != null && date != selectedDate) {
                                          ref.read(dateProvider.notifier).state = date;
                                          ref.read(isSelected.notifier).state = true;
                                        }
                                      },
                                      child: isDateSelected?Text(
                                        'Tap to change',
                                        style: theme.textTheme.titleMedium,
                                      ):Text(
                                        'Tap to select date',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                isDateSelected
                                    ? Row(
                                      children: [
                                        Text('Selected date is :  ',style: theme.textTheme.titleMedium,),
                                        Text(
                                          '${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                                          style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                                        ),
                                      ],
                                    )
                                    : SizedBox.shrink(),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel', style: theme.textTheme.titleMedium),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(bookmarkProvider.notifier).filterByDate(ref.read(dateProvider));
                                  Navigator.pop(context);
                                },
                                child: Text('Filter', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                },
                icon: Icon(
                  Icons.tune,
                  color: theme.iconTheme.color,
                ),
              ),
            ),
            onChanged: (value){
              notifier.searchBookmarks(value);
            },
          ),
        ),
      ),
    );
  }
}

class BookmarkWidget extends StatelessWidget {
  final ThemeData theme;
  final String imageUrl;
  final String title;
  final String chipTitle;
  final VoidCallback onPressed;
  final VoidCallback onBookmark;
  final VoidCallback onReadLater;
  final bool? isMarked;

  const BookmarkWidget({
    super.key,
    required this.theme,
    required this.imageUrl,
    required this.title,
    required this.chipTitle,
    required this.onPressed,
    required this.onBookmark,
    required this.onReadLater,
    this.isMarked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:20.w ,vertical: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 150.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.65),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 5.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                child: Text(title,maxLines: 2,style: theme.textTheme.titleMedium,overflow: TextOverflow.ellipsis,),

              ),
             Padding(
                 padding: EdgeInsets.symmetric(horizontal: 15.w,),
                 child: TextButton(
                     onPressed: onPressed,
                     style: TextButton.styleFrom(
                       padding: EdgeInsets.zero
                     ),
                     child: Text('Read more...',style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),)
                 ),
             ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w,),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      padding: const EdgeInsets.all(10),
                      side: BorderSide.none,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      label: Text(
                        chipTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                        onTap: onReadLater,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: theme.colorScheme.primary,
                          child: Icon(Icons.watch_later_outlined,color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 15.w,),
                      GestureDetector(
                        onTap: onBookmark,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: theme.colorScheme.primary,
                          child: isMarked == true?Icon(Icons.bookmark,color: Colors.white,):Icon(Icons.bookmark_border,color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 25.w,),
              ],
            ),
            SizedBox(height: 20.h,),

          ],
        ),
      ),
    );
  }
}
