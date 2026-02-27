import 'package:flutter/material.dart';
import 'app_theme.dart';

class AgreementConstants {
  // ──────────────────────────────────────────────
  // KVKK Aydınlatma Metni
  // ──────────────────────────────────────────────
  static void showKvkkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "KVKK Aydınlatma Metni",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              kvkkAgreement,
              style: const TextStyle(fontSize: 13, color: AppColors.darkBlue),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Kapat",
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Ek Sözleşme
  // ──────────────────────────────────────────────
  static void showEkSozlesmeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Ek Sözleşme",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              ekSozlesme,
              style: const TextStyle(fontSize: 13, color: AppColors.darkBlue),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Kapat",
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static void showMembershipAgreementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Üyelik Sözleşmesi",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              membershipAgreement,
              style: const TextStyle(fontSize: 13, color: AppColors.darkBlue),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Kapat",
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static const String membershipAgreement = """
Kişisel Verilerin Korunması
İzersan Yapı Malzemeleri San. ve Tic. Ltd. Şti.  (www.dryix.com.tr) olarak herhangi bir şekilde eriştiğimiz gerçek kişilere ait tüm kişisel verilerin korunmasına ve bu kapsamda Kanun ve ilgili mevzuat çerçevesindeki gereklilikleri tam olarak yerine getirmeyi ilke haline getirmiş bulunuyoruz.

İşbu Aydınlatma metni, Www.Dryfix.Com.Tr. adresindeki sitemizin kullanıcılarının, internet sitemizde toplanan kişisel verilerin kaydedilmesi, işlenmesi, paylaşılması, üçüncü taraflara aktarılması, saklanması, silinmesi ve imhası süreçleri ile bunlara ilişkin ilkelerimiz hakkında bilgilendirilmesi amacıyla hazırlanmıştır.

İZERSAN YAPI MALZEMELERİ SAN. VE TİC. LTD. ŞTİ. , yürürlükteki ilgili mevzuat hükümleri gereğince bilginin gizliliğinin ve bütünlüğünün korunması amacıyla gerekli organizasyonu kurmak ve teknik önlemleri almak ve uyarlamak konusunda veri sorumlusu sıfatıyla sorumluluğu üstlenmiştir.

İZERSAN YAPI MALZEMELERİ SAN. VE TİC. LTD. ŞTİ. , kişisel verilere yetkisiz erişim veya bu bilgilerin kaybı, hatalı kullanımı, ifşa edilmesi, değiştirilmesi veya imha edilmesine karşı korumak için gerekli önlemleri almaktadır.

İZERSAN YAPI MALZEMELERİ SAN. VE TİC. LTD. ŞTİ. , herhangi bir ihlali fark ettiği anda kullanıcıları bu konuda vakit kaybetmeksizin bilgilendirir, yasalara uygun bir şekilde takibinin yapılmasına olanak tanır ve bilgilerinin güvenliğini elinden gelen en iyi şekilde sağlar.

1. Kişisel Veri Tanımı
İşbu Kişisel Verilerin Korunması Politikasında kullanılan “Kişisel Bilgiler” terimi, isim, soy isim, doğum tarihi ve doğum yeri, telefon numarası, motorlu taşıt plakası, sosyal güvenlik numarası, pasaport numarası, özgeçmiş, resim, görüntü ve ses kayıtları, parmak izleri, e-posta adresi gibi bir gerçek kişi ile ilişkilendirilebilen bilgileri ifade etmektedir.

1. Kişisel Verilerin Toplanmasının Yasal Dayanağı
Kullanıcıların kişisel verilerinin kullanılması konusunda çeşitli kanunlarda düzenlemeler bulunmaktadır. En başta Anayasa’nın 20. maddesi, 5651 sayılı Internet Ortamında Yapılan Yayınların Düzenlenmesi ve Bu Yayınlar Yoluyla İşlenen Suçlarla Mücadele Edilmesi Hakkında Kanun ve 6698 sayılı Kişisel Verilerin Korunması Kanunu ve bağlı mevzuat ile kişisel verilerin korunması esasları belirlenmiştir.

1. Kişisel Verilerin Toplanma Yöntemleri
Www.Dryfix.Com.Tr  hesabını kullanırken doğrudan paylaşılan kullanıcı adı, şifre, e-mail, doğum tarihi, cinsiyet ve benzeri verilerle otomatik olarak elde edilen, görüntülenen sayfalar, ziyaret süreleri gibi siteye giriş bilgileri, çerezler vasıtasıyla elde edilen bilgiler, konum bilgileri, tarayıcı tipi ve dili, cihaz modeli gibi verileri ürün ve hizmetlerimizi sağlayabilmek için gereken süre boyunca saklıyoruz. Yer sağlayıcı olarak yasal yükümlülüğümüz gereğince kullanıcıların Www.Dryfix.Com.Tr’deki hesabını kullanırken otomatik olarak elde edilen IP bilgilerini yasal süre boyunca saklıyoruz.

Bununla birlikte www.dryfix.com.tr’de bir hesabı olmaksızın veya hesabına giriş yapılmaksızın sitenin ziyaret edilmesi ve kullanılması durumunda otomatik olarak görüntülenen sayfalar, ziyaret süreleri gibi siteye giriş bilgileri, IP bilgileri, çerezler vasıtasıyla elde edilen bilgiler, konum bilgileri, tarayıcı tipi ve dili, cihaz modeli gibi verileri anonim olarak ürün ve hizmetlerin sağlanabilmesi amacıyla gereken süre boyunca saklıyoruz.

Www.Dryfix.Com.Tr’de bulunduğunuz süre boyunca tarayıcınıza çerezlerin ve buna benzer unsurların yerleştirilmesi söz konusu olabilir. Ayrıntılı bilgi için lütfen çerez politikamızı ziyaret ediniz.

1. Kişisel Verilerin Kullanıldığı Alanlar
Kişisel Bilgiler aşağıdaki amaçlar için kullanılacaktır, hiçbir durumda verinin alınması ile ilgili olan ve verinin alındığı mecrada aydınlatma metninde belirtilen amacın dışında kullanılmayacaktır.

1. Kişisel Bilgilerinin Paylaşımı
Www.Dryfix.Com.Tr adlı internet sitesinden temin edilen Kişisel Bilgiler, verilen hizmetin amacına yönelik olup, ilke olarak, üçüncü kişilere satılmaz, kiralanmaz ya da başka şekilde kullandırılmaz ve üçüncü kişilerle hiçbir suretle paylaşılmaz.

Ancak İZERSAN YAPI MALZEMELERİ SAN. VE TİC. LTD. ŞTİ. ilgili hizmetlerin sunulması ve ticari faaliyetin yürütülmesi açısından gerekli ve zorunlu hallerde gerekli tedbirleri alarak ve mevzuatın izin verdiği çerçevede bilgileri tedarikçileri, çalışanları, danışmanları, iş ortakları ve diğer ilgili 3. Kişilerle paylaşabilecektir. Bu ilgili 3. Kişiler ilgili mevzuat çerçevesinde yurt dışında bulunan gerçek veya tüzel kişiler olabileceklerdir.

Ancak İZERSAN YAPI MALZEMELERİ SAN. VE TİC. LTD. ŞTİ. yürürlükteki mevzuat uyarınca yetkili, idari ve resmi makamlardan usulüne uygun olarak talep gelmesi halinde kullanıcının uhdesinde bulunan bilgilerini ilgili yetkili makamlarla paylaşabilir.

1. Kişisel Verilerin Korunması Kanunu uyarınca kullanıcıların hakları:
KVKK uyarınca kişisel verilerinizin;
1. İşlenip işlenmediğini öğrenme,
2. İşlenmişse bilgi talep etme,
3. İşlenme amacını ve amacına uygun kullanılıp kullanılmadığını öğrenme,
4. Yurt içinde/yurt dışında aktarıldığı 3. kişileri bilme,
5. Eksik/yanlış işlenmişse düzeltilmesini isteme,
6. KVKK’ nın 7. maddesinde öngörülen şartlar çerçevesinde silinmesini/yok edilmesini isteme,
7. Aktarıldığı 3. kişilere yukarıda sayılan (d) ve (e) bentleri uyarınca yapılan işlemlerin bildirilmesini isteme,
8. Münhasıran otomatik sistemler ile analiz edilmesi nedeniyle aleyhinize bir sonucun ortaya çıkmasına itiraz etme,
9. KVKK’ya aykırı olarak işlenmesi sebebiyle zarara uğramanız hâlinde zararın giderilmesini talep etme haklarına sahip olduğunuzu hatırlatmak isteriz.
10. Kişisel Verilerinizin Kaydedilmesine ilişkin Rızanız
Www.Dryfix.Com.Tr adlı internet sitemizi kullandığınız alandan itibaren sizden toplanan tüm bilgileri yukarıda belirtilen şekilde ve nedenlerle, bu politikada anlatıldığı gibi, kullanmamızı kabul etmiş olursunuz. Yukarıdaki amaç için elde edilen bilgiler, tamamen sizin özgür iradenizle tarafımıza sağlanmaktadır. Bu Kişisel Bilgileri bize verip vermemekte kullanıcılar serbesttir.

1. Politika’nın güncellenmesi
Politikamızı ve kişisel bilgileri işleme şeklimizi muhtelif zamanlarda gözden geçirebilir, tadil edebilir veya yenileyebiliriz. Güncellenmiş Politika’yı Www.Dryfix.Com.Tr  adresinde bulunan internet sitemizden yayımlayacağız. Yenilenen şartlar, yayımlandıkları tarihten itibaren yürürlüğe gireceklerdir.

Kişisel Veri Sahipleri, sorularını, görüşlerini veya taleplerini yazılı olarak Info@Izersan.Com.Tr iletmelidir. Bu halde 30 gün içerisinde yazılı şekilde cevap verilecektir.

İZERSAN YAPI MALZEMELERİ SAN. VE TİC. LTD. ŞTİ.
""";

  // ──────────────────────────────────────────────────────────────────────────
  // KVKK metni (avukattan gelecek nihai metin buraya eklenecek)
  // ──────────────────────────────────────────────────────────────────────────
  static const String kvkkAgreement = """
KVKK Aydınlatma Metni

Bu metin, avukattan alınacak nihai belgeye göre güncellenecektir.

İZERSAN YAPI MALZEMELERİ SAN. VE TİC. LTD. ŞTİ. tarafından işlenen kişisel verilerinize ilişkin aydınlatma metnidir.

Kişisel verileriniz, 6698 sayılı Kişisel Verilerin Korunması Kanunu kapsamında işlenmekte olup sipariş işlemlerinin gerçekleştirilmesi amacıyla kullanılmaktadır.

(Nihai metin avukattan gelen PDF dokümanına göre güncellenecektir.)
""";

  // ──────────────────────────────────────────────────────────────────────────
  // Ek Sözleşme metni (avukattan gelecek nihai metin buraya eklenecek)
  // ──────────────────────────────────────────────────────────────────────────
  static const String ekSozlesme = """
Ek Sözleşme

Bu metin, avukattan alınacak nihai belgeye göre güncellenecektir.

İşbu ek sözleşme, İZERSAN YAPI MALZEMELERİ SAN. VE TİC. LTD. ŞTİ. ile alıcı arasında, yapılan satın alma işlemine ilişkin hüküm ve koşulları düzenlemektedir.

(Nihai metin avukattan gelen PDF dokümanına göre güncellenecektir.)
""";
}
