import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;

  const HistoryItem({
    super.key,
    required this.title,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p12),
      padding: EdgeInsets.all(SizeTokens.p12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeTokens.p8),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SizeTokens.r12),
            ),
            child: Icon(icon, color: AppColors.blue, size: SizeTokens.p20),
          ),
          SizedBox(width: SizeTokens.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: SizeTokens.f14 * 0.8,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.gray),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
