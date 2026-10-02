# وصّلني V9 Premium

منصة توصيل عراقية متعددة الخدمات: أكل، بقالة، صيدلية، ورد وهدايا، حيوانات ومتاجر.

## الواجهة
- هوية جديدة: كحلي ملكي + مرجاني + كريمي، مختلفة عن طلبات/توترز.
- Home جديد Mobile-first.
- اكتشاف، مطعم، سلة، Checkout، طلباتي، حساب، دعم.
- واجهات Restaurant OS / Courier OS / Admin Operations.

## Supabase
1. افتح Supabase Project.
2. SQL Editor → الصق `supabase/schema.sql` → Run.
3. فعّل Realtime للجداول التي يضيفها السكربت.
4. انسخ `config.example.js` إلى `config.js` وضع URL + Publishable/Anon key.
5. لا تضع Service Role Key أو مفاتيح الدفع في المتصفح.

## Edge Functions
- `create-payment`
- `payment-webhook`
- `dispatch-order`
- `send-notification`
- `calculate-delivery`

Deploy عبر Supabase CLI أو Dashboard. مفاتيح ZainCash/FastPay/QiCard توضع كـSecrets، وليس داخل `config.js`.

## تشغيل محلي سريع
يمكن فتح `index.html` مباشرة للواجهة التجريبية، أو استخدم static server. بعض خصائص GPS/Service Worker تحتاج HTTPS أو localhost.

## ملاحظات Live
الدفع الحقيقي يحتاج حساب تاجر ومفاتيح API وWebhook من مزود الدفع. الخرائط الحية تحتاج مزود خرائط/Map SDK ومفتاحه. الإشعارات Push تحتاج إعداد Web Push/FCM أو مزود مماثل.
