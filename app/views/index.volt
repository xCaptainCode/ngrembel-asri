<!DOCTYPE html>
<html lang="id">

<head>
   <meta charset="UTF-8" />
   <meta name="viewport" content="width=device-width,initial-scale=1.0" />
   <title>Ngrembel Asri</title>
   <link
      href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;0,700;1,300;1,400;1,600&family=Jost:wght@200;300;400;500;600&family=Great+Vibes&display=swap"
      rel="stylesheet" />

   {% include 'layouts/header.volt' %}

   {{ stylesheet_link("css/dashboard.css") }}
</head>

<body>

   <!-- CURSOR -->
   <div id="cursor"></div>
   <div id="cursor-ring"></div>

   {{ partial("template/navbar") }}

   <main>
      {{ content() }}
   </main>

   {{ partial("template/footer") }}

   {{ javascript_include("js/dashboard.js") }}

</body>

</html>