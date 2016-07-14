<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Help</title>
    <style>
        code {
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
<h1>Советы по написанию R-scripts</h1>

<h2>Данные</h2>

<p>Сейчас реализована поддержка файлов с данными в формате .json, .csv и .xls/.xlsx, примеры см. <a
        href="https://github.com/lanit-tercom-school/analyzeme/wiki">Wiki home</a>. Имя файла должно удовлетворять
    регулярному выражению <code>[A-Za-z0-9,_.]+</code>.</p>

<p>Для обращения к данным в файлах, загруженных в репозиторий (позднее - к данным из других источников),
    пользователь в своём скрипте должен использовать переменные специального вида. Название переменной
    должно удовлетворять регулярному выражению <code>([A-Za-z]+)_from__([A-Za-z]+)__([A-Za-z0-9,_.]+)__</code> и
    состоять из:

<ul>
    <li>название "колонки" данных (для точек это x или y)</li>
    <li>специальное выражение _from__</li>
    <li>указание на источник данных (сейчас поддерживается только repo для загруженных в FileRepository файлов)</li>
    <li>название источника, окружённое символами __ - например, <code>__0_10.json__</code> - сейчас уникальное имя файла
        в репозитории
    </li>
</ul>
</p>

<h3>Итого, примеры названий переменных:</h3>
<code style=display:block;>
    x_from__repo__0_10.json__
    y_from__repo__0_10.json__
    time_from__repo__0_10.json__
    //in the future
    y_from__webRepo__webToken__
</code>

<p>Реальная инициализация этих переменных будет происходить на стороне сервера перед запуском скрипта. Использовать же
    их в скрипте нужно как R-вектора соответствующего типа (сейчас поддерживается только double).</p>

<h2>Написание скрипта</h2>

<p>Для разработки анализатора, использующего язык R, почти не нужно знаний, специфических для нашего проекта. Необходимо
    только понимать, в каком виде представлены исходные данные - и что написать в последней строчке.</p>

<h3> Типы данных: выход </h3>

<p>В процессе написания скрипта можно использовать практически любые package и команды R (неопределённое поведение может
    вызвать работа с графикой, избегайте её). Важно, чтобы результат его работы удовлетворял одному из приведённых ниже
    форматов.</p>

<p>В данный момент корректно будет обработан только double-результат, в ближайшее время предполагается добавить какой-то
    формат для работы со временем. Таким образом, сейчас вы можете написать скрипт, который вернёт:
<ul>
    <li>Скаляр (<i>SCALAR/DOUBLE</i>)</li>
    <li>Безымянный вектор (<i>VECTOR</i>)</li>
    <li>Набор именованных векторов (<i>FILE</i>)</li>
    <li>Неопределённый результат (<i>JSON_STRING</i>)</li>
</ul>
</p>

<p>Для того, чтобы вернуть результат работы R скрипта на сторону Java, достаточно прописать нужную переменную или
    команду
    на последней строчке. </p>

<h4>Скалярный результат </h4>
<p>Выберите в качестве результата SCALAR или DOUBLE</p>

<p>Последней указанной переменной/результатом работы последней команды в скрипте должен быть double-вектор длины 1.</p>

<p>Примеры скриптов: </p>

<code style=display:block;>
    a <- x_from__repo__0_10.json__[5];
    b <- mean(time_from__repo__lineal.csv__);
    result <- a + b</code>

<code style=display:block;>
    mean(time_from__repo__lineal.csv__)</code>

<h4>Результат - безымянный вектор</h4>
<p>Выберите в качестве результата VECTOR</p>

<p>Последней указанной переменной/результатом работы последней команды в скрипте должен быть double-вектор любой длины.
    Используйте такой вид результата в случае, если название вектора могло бы совпадать с названием вашего анализатора,
    но
    не с именем одной из "колонок". </p>

<p>Примеры скриптов:</p>

<code style=display:block;>
    a <- x_from__repo__0_10.json__[5];
    b <- mean(time_from__repo__lineal.csv__);
    r <- c(a, b)</code>

<code style=display:block;>
    c(mean(x_from__repo__0_10.json__), time_from__repo__lineal.csv__)</code>

<h4>Набор именованных векторов</h4>
<p>Выберите в качестве результата FILE</p>

<p>Используйте этот вид результата в случае, если хотите вернуть несколько векторов (именованных или нет), или тогда,
    когда
    имя вектора имеет значение. Возможных типов значения в конце скрипта сейчас два. </p>

<p>Во-первых, data.frame. При желании имена векторов, использованных при его создании, можно менять и вручную, главное
    упомянуть нужную переменную/выполнить нужную команду на последней строке. </p>

<p>Пример скрипта: </p>
<code style=display:block;>
    z <- data.frame(x_from__repo__0_10.json__, time_from__repo__lineal.csv__ + 3);
    names(z) <- c("new col_0 name", "new col_1 name");
    z</code>
<p>Во-вторых, можно использовать обычную матрицу. </p>

<p>Примеры:</p>

<code style=display:block;>
    m <- cbind(x_from__repo__0_10.json__, time_from__repo__lineal.csv__);
    colnames(m) <- c("new col_1 name", "new col_0 name");
    m</code>

<code style=display:block;>
    m <- cbind(x_from__repo__0_10.json__, time_from__repo__lineal.csv__);
    m</code>

<code style=display:block;>
    m <- matrix(c(1, 2, 3, 4), nrow = 2, byrow=TRUE);
    m</code>

<p>В последнем случае имена колонок результата будут сформированы автоматически в виде col0...coln.</p>

<h4>Неопределённый результат</h4>

<p>В случае, если в начале скрипта вы указали JSON_STRING, результатом его выполнения можно делать
    что угодно (кроме графики). Это возможный, но не рекомендуемый вариант, т.к. его корректная обработка для
    представления
    результата пользователю сомнительна. Используйте только для экзотических статистик или в рамках отладки. </p>
</body>
</html>
