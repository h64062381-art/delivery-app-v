# وصّلني V6 — Iraq Delivery OS 🇮🇶

نسخة UI/UX متقدمة جداً مع أساس Backend حقيقي قابل للتشغيل على Supabase.

## الجديد
- هوية بصرية أصلية بالكامل، Dark Luxury + Emerald، بدون تقليد طلبات أو توترز.
- Customer experience: اكتشاف، تصنيفات، مطعم، منيو، سلة، Checkout، طلباتي، تتبع، دعم، حساب.
- Restaurant OS: أساس إدارة الطلبات، المنيو، العروض، الساعات والتقارير.
- Courier OS: أساس GPS، الرحلات، الحالة online/offline والتتبع.
- Admin OS: مؤشرات تشغيل ومركز عمليات.
- PWA + Service Worker + Web Push foundation.
- GPS من المتصفح + خريطة OpenStreetMap للتتبع.
- Supabase schema لملفات العملاء والمطاعم والمنيو والطلبات والمندوبين والدفع والتقييمات والدعم والمحفظة.
- Edge Function scaffolds للدفع، webhooks، وdispatch.
- دعم معماري لبوابات ZainCash / FastPay / QiCard / FIB.

## تشغيل سريع
1. ارفع الملفات إلى الاستضافة.
2. انسخ `config.example.js` إلى `config.js` وضع Supabase URL + anon key.
3. طبّق `supabase/schema.sql` على مشروع Supabase.
4. فعّل RLS وRealtime قبل الإنتاج.
5. انشر Edge Functions، ثم أضف أسرار بوابة الدفع في Secrets فقط.

## الدفع العراقي
الواجهة تحتوي خيارات ZainCash وFastPay وQiCard/FIB، لكن لا يوجد مفتاح تاجر حقيقي داخل المشروع. يجب إكمال onboarding التجاري والحصول على credentials ثم تنفيذ adapter server-side. توثيق ZainCash الحالي يدعم redirect + inquiry + webhooks، وQiCard يوفر REST/3DS، وFastPay يوفر تكامل API للمواقع والتطبيقات.

## مهم تجارياً
المطاعم الموجودة في الواجهة بيانات Demo لتوضيح التجربة، وليست قائمة شركاء حقيقية. إطلاق المنصة يحتاج onboarding واتفاقيات مع المطاعم، بيانات منيو رسمية، مناطق خدمة، أسعار/عمولات، أسطول مندوبين، بوابات دفع، سياسات خصوصية وشروط استخدام، واختبارات تحميل وأمان.
