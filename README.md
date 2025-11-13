
# README - العمل التطبيقي: التحليل الاستكشافي والتصوّر البياني خطوة‑بخطوة
**ملف المشروع:** `tp_visualustion2.ipynb`

## مقدمة
هذا المستند يشرح العمل التطبيقي خطوة بخطوة لاستخدام بيانات البنك الدولي (World Bank) — أو أي مجموعة بيانات مماثلة — للقيام بـ Exploratory Data Analysis (EDA) وتصوير النتائج تفاعليًا وجغرافيًا. الشرح مكتوب بالعربية وموجّه للاستخدام مباشرة داخل **Google Colab** أو **Jupyter Notebook**.

---
## محتويات المشروع (الملف التنفيذي)
1. تحميل المكتبات الضرورية وتثبيتها
2. جلب البيانات تلقائيًا من البنك الدولي أو تحميلها يدويًا
3. تنظيف وتحضير البيانات (تنسيق الأعمدة الزمنية، التعامل مع القيم المفقودة)
4. تحليلات وصفية غير رسومية (متوسط، وسيط، منوال، انحراف معياري،skew،kurtosis)
5. رسوم وصفية: Histogram و Boxplot و Boxplot مجمّع حسب فئات
6. تحليل الترابط: مصفوفة correlation وHeatmap
7. رسوم مقارنة: Scatter, Bubble, Density
8. رسوم تفاعلية: Plotly time series و interactive scatter
9. خريطة جغرافية تفاعلية: Folium Choropleth
10. رسم شبكة هرمية: NetworkX
11. حفظ النتائج + تصدير ملفات (CSV, PNG, HTML)
12. خلاصة واستنتاجات

---
## إرشادات التشغيل (تشغيل سريع)
1. افتح `tp_visualustion2.ipynb` في Google Colab أو Jupyter.
2. شغّل الخلايا من الأعلى إلى الأسفل بالترتيب.
3. إن لم تكن البيانات مضمنة، ستجد خلية تحمل اسم "تحميل البيانات" تستخدم `wbgapi` لتحميل المؤشرات التالية من البنك الدولي:
   - NY.GDP.MKTP.CD  (GDP current US$)
   - SP.DYN.LE00.IN  (Life expectancy)
   - IT.NET.USER.ZS   (Internet users %)
   - SP.POP.TOTL      (Population)
4. إن لم يعمل التحميل، يمكنك رفع ملف CSV باسم `global_indicators.csv` في نفس مجلد النوتبوك.

---
## شرح خطوة‑بخطوة (تفصيلي)

### الخطوة 1 — تثبيت واستيراد المكتبات
**ماذا تفعل:** تثبيت المكتبات (wbgapi, pandas, seaborn, plotly, folium, networkx) واستيرادها.
**هدف:** التأكد أن البيئة جاهزة للتنفيذ.
**أمر تجريبي:**

```python
!pip install wbgapi pandas matplotlib seaborn plotly folium networkx -q
import pandas as pd, numpy as np, matplotlib.pyplot as plt, seaborn as sns
import plotly.express as px, wbgapi as wb, folium, networkx as nx
```

---

### الخطوة 2 — تحميل البيانات وتنظيفها
**ماذا تفعل:** تستخدم `wbgapi` لسحب المؤشرات المطلوبة بين سنوات محددة (مثلاً 2000–2023)، ثم تحويل الإطار لهيكل مناسب.
**أهداف التنظيف:**
- توحيد أسماء الأعمدة (`Country`, `Year`, `GDP_Per_Capita`, ...)
- حذف أو ملء القيم المفقودة (اختياري: `dropna()` أو `fillna()`)
- تحويل الأعمدة الزمنية إلى `int` أو `datetime` إذا لزم
**كود نموذجي:**

```python
indicators = {
 'NY.GDP.MKTP.CD':'GDP_Per_Capita',
 'SP.DYN.LE00.IN':'Life_Expectancy',
 'IT.NET.USER.ZS':'Internet_Users_Pct',
 'SP.POP.TOTL':'Population'
}
df = wb.data.DataFrame(indicators, time=range(2000,2023), labels=True).reset_index()
df.rename(columns={'economy':'Country','time':'Year'}, inplace=True)
df.dropna(inplace=True)  # أو اختيار سياسة تعبئة مختلفة
```

---

### الخطوة 3 — استكشاف أولي (head, info, describe)
**ماذا تفعل:** معاينة بنية البيانات وفحص القيم المفقودة والتوزيعات العامة.
**أوامر مهمة:** `df.head()`, `df.info()`, `df.describe(include='all')`

**هدف الاختبار:** التأكد من كمية البيانات ونطاق السنوات وتوزيع المتغيرات.

---

### الخطوة 4 — إحصاءات وصفية غير رسومية
**ماذا تفعل:** حساب المتوسط، الوسيط، المنوال، الانحراف المعياري، المدى، Skewness وKurtosis.
**كود:**

```python
mean = df['GDP_Per_Capita'].mean()
median = df['GDP_Per_Capita'].median()
mode = df['GDP_Per_Capita'].mode()[0]
std = df['GDP_Per_Capita'].std()
skewness = df['GDP_Per_Capita'].skew()
kurt = df['GDP_Per_Capita'].kurtosis()
```

**مخرجات متوقعة:** أرقام موجزة توضح انتشار وتوزيع المتغيرات.

---

### الخطوة 5 — رسوم وصفية أساسية
**Histogram و Boxplot** لمتغيرات مثل GDP_Per_Capita و Life_Expectancy و Internet_Users_Pct.
**نصائح عرض:** استخدم `log` للمحور السيني عند GDP بسبب التفاوت الكبير بين الدول.
**كود مختصر:**

```python
plt.figure(figsize=(8,5))
sns.histplot(df['Life_Expectancy'], bins=30, kde=True)
plt.title('Distribution of Life Expectancy')
plt.show()

plt.figure(figsize=(8,4))
sns.boxplot(x='Life_Expectancy', data=df)
plt.show()
```

---

### الخطوة 6 — مقارنة رسومية (Scatter, Bubble, Density)
**ماذا تفعل:** رسم Scatter (log scale GDP vs Life), Bubble (بحجم Population)، وDensity/Hexbin.
**لماذا:** لفهم التشتت والكتل وتأثير الحجم السكاني على المتوسط العالمي.

**كود مختصر:**

```python
plt.scatter(np.log10(df['GDP_Per_Capita']), df['Life_Expectancy'], s=df['Population']/1e7, alpha=0.5)
plt.xscale('log')  # أو استخدم log قبل الرسم
plt.xlabel('GDP per Capita (log10)')
plt.ylabel('Life Expectancy')
```

---

### الخطوة 7 — مصفوفة الارتباط Heatmap
**ماذا تفعل:** حساب معامل بيرسون واظهار Heatmap مع القيم المعلّمة.
**كود:**

```python
num_cols = ['GDP_Per_Capita','Life_Expectancy','Internet_Users_Pct','Population']
corr = df[num_cols].corr()
sns.heatmap(corr, annot=True, cmap='coolwarm', center=0)
```

**التحليل:** حدد الأزواج ذات أعلى قيمة مطلقة (قيمة قريبة من ±1).

---

### الخطوة 8 — رسم تفاعلي للزمن (Plotly)
**ماذا تفعل:** استخدم `px.line` لخط تفاعلي يعرض GDP للفرد عبر الزمن لبلدين.
**كود:**

```python
countries = ['United States','India']
fig = px.line(df[df['Country'].isin(countries)], x='Year', y='GDP_Per_Capita', color='Country', markers=True)
fig.show()
```

---

### الخطوة 9 — خريطة تفاعلية (Folium Choropleth)
**ماذا تفعل:** رسم خريطة Choropleth للمتغير (مثلاً Life_Expectancy) للعام الأخير.
**ملاحظات:** تحتاج ملف GeoJSON أو رابط معه أسماء الدول متطابقة مع عمود `Country`.
**كود:**

```python
latest = df[df['Year']==df['Year'].max()]
m = folium.Map(location=[20,0], zoom_start=2)
folium.Choropleth(geo_data='world-countries.json', data=latest, columns=['Country','Life_Expectancy'], key_on='feature.properties.name', fill_color='YlGnBu').add_to(m)
m.save('life_expectancy_map.html')
```

---

### الخطوة 10 — رسم شبكة هرمية (NetworkX)
**ماذا تفعل:** نمذجة تسلسل هرمي World→Region→Country واظهاره.
**كود مبسط:**

```python
G = nx.DiGraph()
G.add_node('World')
for r in df['Region'].unique():
    G.add_edge('World', r)
    for c in df[df['Region']==r]['Country'].unique()[:10]:
        G.add_edge(r, c)
nx.draw(G, with_labels=True, node_size=1000, font_size=8)
```

---

### الخطوة 11 — التصدير والحفظ
- حفظ CSV: `df.to_csv('global_indicators_clean.csv', index=False)`
- حفظ صورة: `plt.savefig('figure.png', dpi=300)`
- حفظ الخريطة: `m.save('map.html')`

---

### الخطوة 12 — التفسير والملخص
أضف خلايا Markdown في نهاية النوتبوك لتلخيص النتائج مع توصيات واضحة مبنية على التحليل.

---
## قائمة التحقق (Checklist) للتسليم
- [ ] Notebook يعمل في Colab
- [ ] بيانات نظيفة
- [ ] رسوم Scatter/Bubble/Density
- [ ] Heatmap مع تفسير
- [ ] خريطة تفاعلية وPlotly time series
- [ ] README يشرح المشروع خطوة بخطوة

---
**إعداد:** Med Med
**تاريخ:** 2025
